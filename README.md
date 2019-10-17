# tinigdb

The `tinigdb` image provides a Docker container running `PostgreSQL` with `PostGIS 2.5` installed and a `tinigdb` database containing a subset of the eHA Nigeria Master GDB within the `nigeria_master` schema.

`tinigdb` consists of the following data:

| States | Tables                 | Views            |
| ------ | ---------------------- | ---------------- |
| Borno  | local_government_areas | boundaries       |
|        | settlement_areas       | locations        |
|        | settlement_points      | settlements_view |
|        | settlements            | wards_view       |
|        | states                 |                  |
|        | wards                  |                  |
