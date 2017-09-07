#!/bin/sh

NETWORK=$(mktemp) &&
    DIND=$(mktemp) &&
    CLIENT=$(mktemp) &&
    VOLUMES=$(mktemp) &&
    SSHD=$(mktemp) &&
    cleanup() {
        echo -e "CLEANUP DIND=\"$(cat ${DIND})\" CLIENT=\"$(cat ${CLIENT})\" NETWORK=\"$(cat ${NETWORK})\" VOLUMES=\"$(cat ${VOLUMES})\"" &&
            docker container stop $(cat ${DIND}) $(cat ${CLIENT}) $(cat ${SSHD}) &&
            docker container rm --force --volumes $(cat ${DIND}) $(cat ${CLIENT}) &&
            docker network rm $(cat ${NETWORK}) &&
            docker volume rm $(cat ${VOLUMES}) &&
            rm -f ${NETWORK} ${DIND} ${CLIENT} ${VOLUMES}
    } &&
    trap cleanup EXIT &&
    docker network create $(uuidgen) > ${NETWORK} &&
    docker volume create > ${VOLUMES} &&
    rm -f ${DIND} &&
    docker \
        container \
        create \
        --cidfile ${DIND} \
        --privileged \
        --volume $(cat ${VOLUMES}):/srv/volumes \
        --volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
        --env DISPLAY \
        docker:17.07.0-ce-dind \
        --host tcp://0.0.0.0:2376 &&
    docker network connect --alias docker $(cat ${NETWORK}) $(cat ${DIND}) &&
    rm -f ${CLIENT} &&
    docker \
        container \
        create \
        --cidfile ${CLIENT} \
        --interactive \
        --tty \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        --volume $(cat ${VOLUMES}):/srv/volumes \
        --workdir /home/user \
        --env DOCKERHUB_USERNAME \
        --env DOCKERHUB_PASSWORD \
        --env DOCKER_HOST="tcp://docker:2376" \
        --env DISPLAY \
        --volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
        endlessplanet/client &&
    docker network connect $(cat ${NETWORK}) $(cat ${CLIENT}) &&
    rm ${SSHD} &&
    docker \
        container \
        create \
        --cidfile ${SSHD} \
        rastasheep/ubuntu-sshd:14.04 &&
    docker network connect --alias sshd $(cat ${NETWORK}) $(cat ${SSHD}) &&
    docker container start $(cat ${DIND}) &&
    docker container start --interactive $(cat ${CLIENT}) &&
    docker container start $(cat ${SSHD})