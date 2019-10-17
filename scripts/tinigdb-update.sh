#!/bin/sh
set -e

# rename borno schema
export PGUSER="$POSTGRES_USER"

echo ">> Rename schema ..."
psql --dbname='tinigdb' <<-'EOSQL'
    ALTER SCHEMA borno RENAME TO nigeria_master;
EOSQL


echo ">> Create views ..."
for f in /usr/src/scripts/*; do
    case "$f" in
        *.sql) echo "$0: running $f"; psql --dbname='tinigdb' -f "$f"; echo ;;
        *)     echo "$0: ignoring $f" ;;
    esac
    echo
done
