--
-- note: this script assumes pg_hba.conf is configured correctly
--

-- \connect postgres postgres

CREATE USER "%PREFIX%hibuser" PASSWORD '%HIBERNATE_PASSWORD%';

CREATE DATABASE "%PREFIX%hibernate" WITH OWNER = "%PREFIX%hibuser" ENCODING = 'UTF8' TABLESPACE = pg_default;

GRANT ALL PRIVILEGES ON DATABASE "%PREFIX%hibernate" to "%PREFIX%hibuser";
