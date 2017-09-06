#!/bin/sh

CID_FILE=$(mktemp) &&
    rm -f ${CID_FILE} &&
    docker container create --cidfile ${CID_FILE} --volume /srv/volumes/homey:/root --volume /var/run/docker.sock:/var/run/docker.sock:ro --env DOCKER_HOST=tcp://docker:2376 docker:17.07.0-ce "${@}" &&
    docker network connect special $(cat ${CID_FILE}) &&
    docker container start --interactive $(cat ${CID_FILE}) &&
    rm ${CID_FILE}
