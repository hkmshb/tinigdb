# tinigdb

The `tinigdb` image provides a Docker container running `PostgreSQL` with `PostGIS 2.5` installed and a `tinigdb` database containing a subset of the eHA Nigeria Master GDB within the `nigeria_master` schema.

## Available Data

`tinigdb` consists of the following data. Subsequent release with extend this list gradually.

| States | Tables                 | Views            |
| ------ | ---------------------- | ---------------- |
| Borno  | local_government_areas | boundaries       |
|        | settlement_areas       | locations        |
|        | settlement_points      | settlements_view |
|        | settlements            | wards_view       |
|        | states                 |                  |
|        | wards                  |                  |

## Setup

The produced `tinigdb` Docker image includes postgres data dump which is restore into the tinigdb database. The data dump is excluded from the repository, but must be present when building the image within the `./data` directory.

The build relies on environment variables to configure created database. Create a `.env` file from `.env.sample` and update as necessary.

Environment Variables:
`POSTGRES_*` env vars configure the default `postgres` database and user
`GDB_*` env vars configure the `tinigdb` scripts, database and user

```sh
# build image; deletes (if exists) and creates associated volume, then creates image
$ make rebuild-image          # or use: 'make rbi'
```

## Scripts

- tinigdb-setup.sh
run once automatically on container startup for a fresh database; creates `tinigdb` user and database, installs necessary extensions (postgis, uuid-ossp), and lastly restores the data dump.
- tinigdb-update.sh
needs to be run once manually to 1) renames schema from the data dump to value provided in `${GDB_SCHEMA_NAME}` env var if the restored schema goes by a different name. 2) run all .sql scripts to create views and other database objects for `tinigdb`.

    ```sh
    # to update tinigdb
    $ make update-tinigdb       # or use: 'make udb'
    ```
