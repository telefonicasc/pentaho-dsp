#!/bin/bash

# Dump the required SQL statements to create the databases
export SQL_HOME=/opt/postgres
for i in create_jcr_postgresql.sql create_repository_postgresql.sql create_quartz_postgresql.sql; do
    sed "s/%SERVER%/${DB_SERVER}/g;s/%PORT%/${DB_PORT}/g;s/%PREFIX%/${DB_PREFIX}/g;s/%PASSWORD%/${DB_PASSWORD}/g;s/%JACKRABBIT_PASSWORD%/${JACKRABBIT_PASSWORD}/g;s/%QUARTZ_PASSWORD%/${QUARTZ_PASSWORD}/g;s/%HIBERNATE_PASSWORD%/${HIBERNATE_PASSWORD}/g" "${SQL_HOME}/$i"
    echo ""
done
