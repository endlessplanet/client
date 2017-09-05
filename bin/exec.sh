#!/bin/sh

CID_FILE=$(mktemp) &&
    rm ${CID_FILE} &&
    docker \
        container \
        create \
        --cidfile ${CID_FILE} \
        --interactive \
        --tty \
        --rm \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        --workdir /home/user \
        --env ID_RSA="$(cat ~/.ssh/id_rsa)" \
        --env KNOWN_HOSTS="$(cat ~/.ssh/known_hosts)" \
        endlessplanet/client &&
    docker container start --interactive $(cat ${CID_FILE})