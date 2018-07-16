#!/bin/bash

SCRIPT_DIR=${OPENEMPI_HOME}/conf
DB_HOST=${POSTGRES_HOST}
DB_NAME=${POSTGRES_DB}
DB_USER=${POSTGRES_USER}
DB_PORT=${POSTGRES_PORT}

export PGPASSWORD=${POSTGRES_PASSWORD}

schemapresent=`psql --dbname=$DB_NAME --host=$DB_HOST --port=$DB_PORT --username=$DB_USER \
  --command="select tablename from pg_tables where tablename='entity_attribute'" | grep entity_attribute`

if [ ! -z $schemapresent ]
then
  echo "OpenEMPI schema has already been created in the database."
  exit 0
fi

echo "Loading scripts from $SCRIPT_DIR"

echo "Creating database schema"
psql --dbname=$DB_NAME --host=$DB_HOST --port=$DB_PORT --username=$DB_USER -f $SCRIPT_DIR/create_new_database_schema-3.0.0.sql

echo "Updating database schema to the latest version ($OPENEMPI_VERSION)"
psql --dbname=$DB_NAME --host=$DB_HOST --port=$DB_PORT --username=$DB_USER -f $SCRIPT_DIR/update_database_schema-3.1.0.sql
psql --dbname=$DB_NAME --host=$DB_HOST --port=$DB_PORT --username=$DB_USER -f $SCRIPT_DIR/update_database_schema-3.2.0.sql
psql --dbname=$DB_NAME --host=$DB_HOST --port=$DB_PORT --username=$DB_USER -f $SCRIPT_DIR/update_database_schema-3.3.0.sql
psql --dbname=$DB_NAME --host=$DB_HOST --port=$DB_PORT --username=$DB_USER -f $SCRIPT_DIR/update_database_schema-3.4.0.sql

echo "Loading person entity definition"
psql --dbname=$DB_NAME --host=$DB_HOST --port=$DB_PORT --username=$DB_USER -f $SCRIPT_DIR/create_person_entity_model_definition.sql

echo "Loading reference data"
psql --dbname=$DB_NAME --host=$DB_HOST --port=$DB_PORT --username=$DB_USER -f $SCRIPT_DIR/create_person_reference_tables.sql

echo "Loading custom configuration data"
for f in *.sql; do
    echo "Loading file: $f"
    psql --dbname=$DB_NAME --host=$DB_HOST --port=$DB_PORT --username=$DB_USER -f $f
done
