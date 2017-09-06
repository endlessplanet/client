#!/bin/sh

CID_FILE=$(mktemp) &&
    rm -f ${CID_FILE} &&
    /usr/local/bin/docker \
        container \
        create \
        --cidfile ${CID_FILE} \
        --volume /srv/volumes/homey:/root \
        --env /USR/Local/bin/docker_HOST=tcp:///docker:2376 docker:17.07.0-ce \
        "${@}" &&
    /usr/local/bin/docker network connect special $(cat ${CID_FILE}) &&
    /usr/local/bin/docker container start --interactive $(cat ${CID_FILE}) &&
    rm ${CID_FILE}
