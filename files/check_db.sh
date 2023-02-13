#!/bin/bash

function schema() {
  # Only ever try to upgrade schema once, otherwise we may break an existing install
  if [ -f "${PENTAHO_HOME}/.firstboot" ]; then
    echo "ABORTING SCHEMA CREATION because .firstboot file already exists"
    echo "If you want to force schema creation, remove the .firstboot file from pentaho-server folder"
    return -1
  fi
  echo "TRYING TO INSTALL SCHEMA"
  if ! . /opt/schema.sh | psql -U postgres -h "${DB_SERVER}" -p "${DB_PORT}"; then
    # Try again without the "CREATE USER" or "CREATE DATABASE" statement
    if ! . /opt/schema.sh | grep -E -v "(CREATE USER|CREATE DATABASE|GRANT ALL)" | psql -U "${DB_PREFIX}pentaho_user" -h "${DB_SERVER}" -p "${DB_PORT}" -d "${DB_PREFIX}quartz"; then
      echo "FAILED TO INSTALL SCHEMA. Check your POSTGRES_PASSWORD environment variable"
      return -2
    fi
  fi
  echo "SCHEMA INSTALLED WITHOUT ERRORS"
}

if [ ! -f "${PENTAHO_HOME}/env.postgresql" ]; then
  echo "REQUIREMENT ERROR: Configuration utility has not been run"
  cat /opt/usage.txt
  exit -200
fi

# Load database information and create .pgpass file
. "${PENTAHO_HOME}/env.postgresql"
if [ -z "$JACKRABBIT_PASSWORD" ]; then export "JACKRABBIT_PASSWORD=${DB_PASSWORD}"; fi
if [ -z "$QUARTZ_PASSWORD" ];     then export "QUARTZ_PASSWORD=${DB_PASSWORD}";     fi
if [ -z "$HIBERNATE_PASSWORD" ];  then export "HIBERNATE_PASSWORD=${DB_PASSWORD}";  fi
if [ -z "${POSTGRES_PASSWORD}" ]; then export "POSTGRES_PASSWORD=${DB_PASSWORD}";   fi

cat > "${PGPASSFILE}" <<EOF
${DB_SERVER}:${DB_PORT}:${DB_PREFIX}jackrabbit:${DB_PREFIX}jcr_user:${JACKRABBIT_PASSWORD}
${DB_SERVER}:${DB_PORT}:${DB_PREFIX}quartz:${DB_PREFIX}pentaho_user:${QUARTZ_PASSWORD}
${DB_SERVER}:${DB_PORT}:${DB_PREFIX}hibernate:${DB_PREFIX}hibuser:${HIBERNATE_PASSWORD}
${DB_SERVER}:${DB_PORT}:*:postgres:${POSTGRES_PASSWORD}
EOF
function cleanup {
  rm -f "${PGPASSFILE}" 2>/dev/null
}
trap cleanup EXIT
chmod 0600 "${PGPASSFILE}"

# Check all databases are there
if ! ( psql -c "SELECT * FROM qrtz5_locks LIMIT 1;" -U "${DB_PREFIX}pentaho_user" -h "${DB_SERVER}" -p "${DB_PORT}" "${DB_PREFIX}quartz" >/dev/null); then
  if ! schema; then
    echo "REQUIREMENT ERROR: Quartz user or database not available"
    cat /opt/usage.txt
    exit -201
  fi
  # quartz schema is "destructive". Once created, we do not want to run it again.
  touch "${PENTAHO_HOME}/.firstboot"
fi
if ! ( psql -c "SELECT 1;" -U "${DB_PREFIX}hibuser" -h "${DB_SERVER}" -p "${DB_PORT}" "${DB_PREFIX}hibernate" >/dev/null); then
  echo "REQUIREMENT ERROR: Hibernate user or database not available"
  cat /opt/usage.txt
  exit -202
fi
if ! ( psql -c "SELECT 1;"  -U "${DB_PREFIX}jcr_user" -h "${DB_SERVER}" -p "${DB_PORT}" "${DB_PREFIX}jackrabbit" >/dev/null); then
  echo "REQUIREMENT ERROR: Jackrabbit user or database not available"
  cat /opt/usage.txt
  exit -203
fi

# No error
exit 0
