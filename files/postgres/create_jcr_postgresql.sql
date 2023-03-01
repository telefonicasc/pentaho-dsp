--
-- note: this script assumes pg_hba.conf is configured correctly
--

-- \connect postgres postgres

CREATE USER "%PREFIX%jcr_user" PASSWORD '%JACKRABBIT_PASSWORD%';

CREATE DATABASE "%PREFIX%jackrabbit" WITH OWNER = "%PREFIX%jcr_user" ENCODING = 'UTF8' TABLESPACE = pg_default;

GRANT ALL PRIVILEGES ON DATABASE "%PREFIX%jackrabbit" to "%PREFIX%jcr_user";
