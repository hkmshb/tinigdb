#!/bin/sh
set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

# create tinigdb
echo ">>Creating tinigdb user ... using pwd: ${GDB_PASSWORD}"
"${psql[@]}" --dbname="$DB" <<-'EOSQL'
    CREATE USER tinigdb
    WITH CREATEDB CREATEROLE LOGIN
         PASSWORD '${GDB_PASSWORD}'
         IN ROLE postgres;
EOSQL

echo ">> Creating tinigdb database ..."
"${psql[@]}" --dbname="$DB" <<-'EOSQL'
    CREATE DATABASE tinigdb
    WITH TEMPLATE=template_postgis
         OWNER tinigdb
EOSQL

# Load PostGIS into both template_database and $POSTGRES_DB
for DB in template_postgis tinigdb "$POSTGRES_DB"; do
  echo ">>Loading UUID extensions into $DB"
  "${psql[@]}" --dbname="$DB" <<-'EOSQL'
      CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL
done

# Restore borno dump file
echo ">> Restoring ${GDB_BACKUP_FILE} dump file ..."
export PGPASSWORD=${GDB_PASSWORD}
backup_file=/usr/src/data/${GDB_BACKUP_FILE}

if [[ ! -f ${backup_file} ]]
then
    echo ">> Backup file not found: ${GDB_BACKUP_FILE} ..."
    exit 1
else
    pg_restore \
        --dbname='tinigdb' \
        --username='tinigdb' \
        --verbose \
        ${backup_file};
fi
