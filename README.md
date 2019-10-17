# tinigdb

The `tinigdb` image provides a Docker container running `PostgreSQL` with `PostGIS 2.5` installed and a `tinigdb` database and user. The container is configured to restore data into the `tinigdb` database from a dump file created using `pg_dump`.

## Setup

The produced `tinigdb` Docker image should include a postgres data dump within the `./data` directory. This dump should never be committed into the repository. The image build process, besides the required dump relies on a number of environment variables for configuring the database. Create a `.env` file from the included `.env.sample` and update as necessary. Find description for the variables below:

```
POSTGRES_DB:
POSTGRES_USER:
POSTGRES_PASSWORD:

GDB_PASSWORD:        password for the tinigdb user
GDB_BACKUP_FILE:     indicate name of the dump file
GDB_SCHEMA_NAME:     the original schema name from the dump
GDB_NEW_SCHEMA_NAME: the name restored schema is to be changed to
```

## Scripts

- tinigdb-setup.sh
run once automatically on container startup for a fresh database; creates `tinigdb` user and database, installs necessary extensions (postgis, uuid-ossp), and lastly restores the data dump.
- tinigdb-update.sh
needs to be run once manually to 1) renames schema from the data dump to value provided in `${GDB_SCHEMA_NAME}` env var if the restored schema goes by a different name. 2) run all .sql scripts to create views and other database objects for `tinigdb`.

## Commands

The repository includes a `Makefile` with commands to ease image build and other related operations.

```sh
# build image; deletes (if exists) and creates associated volume, then creates image
$ make rebuild-image          # or use: 'make rbi'

# to update tinigdb
$ make update-tinigdb       # or use: 'make udb'
```
