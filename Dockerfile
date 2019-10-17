FROM mdillon/postgis:10-alpine

WORKDIR /usr/src
RUN mkdir -p /usr/src/data /usr/src/scripts

COPY ./data/ ./data/
COPY ./scripts/*.sh /usr/local/bin/
COPY ./initdb.d/* /docker-entrypoint-initdb.d/

EXPOSE 5432
