#!/bin/bash

set -e

echo "Starting OpenEMPI..."

dockerize -wait tcp://${POSTGRES_DB}:5432 -timeout 15s bin/startup.sh run &

sleep infinity
