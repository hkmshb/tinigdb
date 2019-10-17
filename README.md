# tinigdb

The `tinigdb` image provides a Docker container running `PostgreSQL` with `PostGIS 2.5` installed and a `tinigdb` database and user. The container is configured to restore data into the `tinigdb` database from a dump file (created using `pg_dump`) placed inside the `./data` directory and run `.sql` scripts within `./data/sql` directory to create other database objects after the restore.

**ATTENTION**: The repository does not (and SHOULD NEVER) contain the data dump and `.sql` scripts.

## Setup

**DUMP & SQL SCRIPTS**  
Place the dump file to restore within the `data` directory found within the same location as the `Dockerfile`. To perform custom operations on the restored database, besides a schema rename which is automatically handled if the right environment variables are set (see ENV VARS section below). Create a `sql` sub-directory inside `data` and place `.sql` scripts for performing custom operations therein.  The container is configured to to automatically execute `.sql` script within the `sql` sub directory immediately after the restore operation.

**ENV VARS**  
The build process for the `tinigdb` Docker image relies on a number of environment variables for configuring the database. Create a `.env` file from the sample `.env.sample` and update as necessary. Find description for the variables below:

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
