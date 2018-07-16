#!/bin/bash

set -e

echo "Starting OpenEMPI..."

dockerize -wait tcp://${POSTGRES_HOST}:${POSTGRES_PORT} -timeout 120s ./create_database.sh run &

sh bin/startup.sh

sleep infinity
