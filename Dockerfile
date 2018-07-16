FROM java:openjdk-8-jdk

RUN apt-get update && apt-get install -y postgresql-client nano net-tools

ENV OPENEMPI_VERSION=3.4.0
ENV OPENEMPI_ENTITY_NAME=openempi-entity-${OPENEMPI_VERSION}c
ENV OPENEMPI_ARCHIVE=${OPENEMPI_ENTITY_NAME}-release.tar.gz
ENV OPENEMPI_HOME_DIR=/usr/share/openempi

ENV OPENEMPI_VERSION ${OPENEMPI_VERSION}
ENV OPENEMPI_HOME ${OPENEMPI_HOME_DIR}/${OPENEMPI_ENTITY_NAME}

RUN mkdir -p ${OPENEMPI_HOME_DIR}
WORKDIR ${OPENEMPI_HOME_DIR}

# Install dockerize
ENV DOCKERIZE_VERSION="v0.2.0"
RUN curl -L "https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz" \
    -o "/tmp/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz" && \
    tar -C /usr/local/bin -xzvf "/tmp/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz"

RUN mkdir -p "${HOME_SHARE}/openxds/" \
    && curl -L "http://www.openempi.org/openempi-downloads/file_download/?username=odysseas@sysnetint.com&filename=${OPENEMPI_ARCHIVE}" \
            -o ${OPENEMPI_ARCHIVE} \
    && tar -zxvf ${OPENEMPI_ARCHIVE} -C . \
    && rm ${OPENEMPI_ARCHIVE}

RUN cp -R openempi-${OPENEMPI_VERSION}c/** . && \
    rm -R openempi-${OPENEMPI_VERSION}c

#The post-install script assume this exists, so create it to please it
RUN mkdir -p ${OPENEMPI_ENTITY_NAME}/bin

#The post-install script assumes this doesn't, so remove it to please it
RUN rm -R ${OPENEMPI_ENTITY_NAME}/fileRepository

ADD jdbc.properties ${OPENEMPI_ENTITY_NAME}/conf/jdbc.properties
ADD boot.sh boot.sh
ADD post-install.sh post-install.sh
ADD setenv.sh bin/setenv.sh
ADD create_database.sh create_database.sh
RUN chmod +x boot.sh && \
    chmod +x post-install.sh && \
    chmod +x bin/setenv.sh && \
    chmod +x create_database.sh

RUN ./post-install.sh ${OPENEMPI_HOME_DIR} ${OPENEMPI_VERSION}

EXPOSE 8080
EXPOSE 3600

CMD ["./boot.sh", "run"]
