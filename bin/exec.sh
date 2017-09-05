#!/bin/sh

NETWORK=$(mktemp) &&
    DIND=$(mktemp) &&
    CLIENT=$(mktemp) &&
    cleanup() {
        docker container stop $(cat ${DIND}) $(cat ${CLIENT}) &&
            docker container rm --force --volumes $(cat ${DIND}) $(cat ${CLIENT}) &&
            docker network rm $(cat ${NETWORK}) &&
            rm -f ${NETWORK} ${DIND} ${CLIENT}
    } &&
    trap cleanup EXIT &&
    docker network create $(uuidgen) > ${NETWORK} &&
    rm -f ${DIND} &&
    docker \
        container \
        create \
        --cidfile ${DIND} \
        --privileged \
        docker:17.07.0-ce-dind \
        --host tcp://0.0.0.0:2376 &&
    docker network connect --alias docker $(cat ${NETWORK}) $(cat ${DIND}) &&
    docker container start $(cat ${DIND}) &&
    rm -f ${CLIENT} &&
    docker \
        container \
        create \
        --cidfile ${CLIENT} \
        --interactive \
        --tty \
        --rm \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        --workdir /home/user \
        --env ID_RSA="$(cat ~/.ssh/id_rsa)" \
        --env KNOWN_HOSTS="$(cat ~/.ssh/known_hosts)" \
        --env DOCKER_HOST="tcp://docker:2376" \
        endlessplanet/client &&
    docker network connect $(cat ${NETWORK}) $(cat ${CLIENT}) &&
    docker container start --interactive $(cat ${CLIENT})