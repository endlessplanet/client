#!/bin/sh

KEY=$(mktemp) &&
    CERT=$(mktemp) &&
    rm -f ${KEY} ${CERT} &&
    (openssl req -x509 -newkey rsa:4096 -keyout ${KEY} -out ${CERT} -days 365 -nodes <<EOF
US
Virginia
Arlington
Endless Planet
Heavy Industries
registry




EOF
    ) &&
    NETWORK=$(mktemp) &&
    DIND=$(mktemp) &&
    CLIENT=$(mktemp) &&
    cleanup() {
        echo -e "CLEANUP DIND=\"$(cat ${DIND})\" CLIENT=\"$(cat ${CLIENT})\" NETWORK=\"$(cat ${NETWORK})\"" &&
            docker container stop $(cat ${DIND}) $(cat ${CLIENT}) &&
            docker container rm --force --volumes $(cat ${DIND}) $(cat ${CLIENT}) &&
            docker network rm $(cat ${NETWORK}) &&
            rm -f ${NETWORK} ${DIND} ${CLIENT} ${KEY} ${CERT}
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
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        --workdir /home/user \
        --env KEY="$(cat ${KEY})" \
        --env CERT="$(cat ${CERT})" \
        --env DOCKERHUB_USERNAME \
        --env DOCKERHUB_PASSWORD \
        --env DOCKER_HOST="tcp://docker:2376" \
        endlessplanet/client &&
    docker network connect $(cat ${NETWORK}) $(cat ${CLIENT}) &&
    docker container start --interactive $(cat ${CLIENT})