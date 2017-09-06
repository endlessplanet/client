#!/bin/sh

NETWORK=$(mktemp) &&
    DIND=$(mktemp) &&
    CLIENT=$(mktemp) &&
    VOLUMES=$(mktemp) &&
    cleanup() {
        echo -e "CLEANUP DIND=\"$(cat ${DIND})\" CLIENT=\"$(cat ${CLIENT})\" NETWORK=\"$(cat ${NETWORK})\" VOLUMES=\"$(cat ${VOLUMES})\"" &&
            docker container stop $(cat ${DIND}) $(cat ${CLIENT}) &&
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
        --add-host registry:172.19.0.2 \
        --volume $(cat ${VOLUMES}):/srv/volumes \
        docker:17.07.0-ce-dind \
        --host tcp://0.0.0.0:2376 --insecure-registry registry:443 &&
    docker network connect --alias docker $(cat ${NETWORK}) $(cat ${DIND}) &&
    docker container start $(cat ${DIND}) &&
    rm -f ${CLIENT} &&
    sleep 5s &&
    # docker container cp daemon.json $(cat ${DIND}):/etc/docker/daemon.json &&
    docker container exec --interactive $(cat ${DIND}) mkdir /etc/docker/certs.d &&
    docker container exec --interactive $(cat ${DIND}) mkdir /etc/docker/certs.d/registry &&
    # docker container cp ${CERT} $(cat ${DIND}):/etc/docker/certs.d/registry/ca.crt &&
    docker container restart $(cat ${DIND}) &&
    sleep 5s &&
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
        endlessplanet/client &&
    docker network connect $(cat ${NETWORK}) $(cat ${CLIENT}) &&
    docker container start --interactive $(cat ${CLIENT})