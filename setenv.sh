#!/bin/bash

VMPARAMS="-Xms512m -Xmx1024m"
export JAVA_OPTS="${VMPARAMS} -Dopenempi.home=${OPENEMPI_HOME} -Djava.security.egd=file:/dev/urandom"
