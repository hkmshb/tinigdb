#!/bin/sh
set -e

# rename borno schema
export PGUSER="$POSTGRES_USER"

if [[ "${GDB_SCHEMA_NAME}" != "" ]] && [[ "${GDB_NEW_SCHEMA_NAME}" != "" ]]
then
    echo ">> Rename schema ..."

    psql --dbname='tinigdb' \
         -v schemaName=${GDB_SCHEMA_NAME} \
         -v newSchemaName=${GDB_NEW_SCHEMA_NAME} \
<<-'EOSQL'
    ALTER SCHEMA :schemaName RENAME TO :newSchemaName;
EOSQL
echo
fi

sql_dirpath=/usr/src/data/sql
if [[ -d ${sql_dirpath} ]]
then
    echo ">> Running custom sql scripts ..."
    for f in ${sql_dirpath}/*; do
        case "$f" in
            *.sql) echo "$0: running $f"; psql --dbname='tinigdb' -f "$f"; echo ;;
            *)     echo "$0: ignoring $f" ;;
        esac
    done
fi
