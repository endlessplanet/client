#!/bin/sh

sh /opt/docker/setup-docker.sh &&
    docker container create --volume /srv/volumes/homey:/root --name login2 --volume /var/run/docker.sock:/var/run/docker.sock:ro --env DOCKER_HOST=tcp://docker:2376 docker:17.07.0-ce login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
    docker network connect special login2 &&
    docker container start --interactive login2 &&
    docker container create --volume /srv/volumes/homey:/root --name pull2 --volume /var/run/docker.sock:/var/run/docker.sock:ro --env DOCKER_HOST=tcp://docker:2376 docker:17.07.0-ce image pull alpine:3.4 &&
    docker network connect special pull2 &&
    docker container start --interactive pull2 &&
    docker container create --volume /srv/volumes/homey:/root --name tag2 --volume /var/run/docker.sock:/var/run/docker.sock:ro --env DOCKER_HOST=tcp://docker:2376 docker:17.07.0-ce image tag alpine:3.4 registry:443/it/my-alpine3:1 &&
    docker network connect special tag2 &&
    docker container start --interactive tag2 &&
    docker container create --volume /srv/volumes/homey:/root --name login --volume /var/run/docker.sock:/var/run/docker.sock:ro --env DOCKER_HOST=tcp://docker:2376 docker:17.07.0-ce login --username user --password password https://registry:443 &&
    docker network connect special login &&
    docker container start --interactive login &&
    docker container create --volume /srv/volumes/homey:/root --name push-alpine --volume /var/run/docker.sock:/var/run/docker.sock:ro --env DOCKER_HOST=tcp://docker:2376 docker:17.07.0-ce image push registry:443/it/my-alpine3:1 &&
    docker network connect special push-alpine &&
    docker container start --interactive push-alpine &&
    docker container create --volume /srv/volumes/homey:/root --name ls21 --volume /var/run/docker.sock:/var/run/docker.sock:ro --env DOCKER_HOST=tcp://docker:2376 docker:17.07.0-ce docker image ls &&
    docker network connect special ls21 &&
    docker container start --interactive ls21 &&
    docker container create --volume /srv/volumes/homey:/root --name rm2 --volume /var/run/docker.sock:/var/run/docker.sock:ro --env DOCKER_HOST=tcp://docker:2376 docker:17.07.0-ce docker image rm alpine:3.4 registry:443/it/my-alpine3:1 &&
    docker network connect special rm2 &&
    docker container start --interactive rm2 &&
    docker container create --volume /srv/volumes/homey:/root --name pull-alpine --volume /var/run/docker.sock:/var/run/docker.sock:ro --env DOCKER_HOST=tcp://docker:2376 docker:17.07.0-ce image pull registry:443/it/my-alpine3:1 &&
    docker network connect special pull-alpine &&
    docker container start --interactive pull-alpine &&
    docker container create --volume /srv/volumes/homey:/root --name ls22 --volume /var/run/docker.sock:/var/run/docker.sock:ro --env DOCKER_HOST=tcp://docker:2376 docker:17.07.0-ce docker image ls &&
    docker network connect special ls22 &&
    docker container start --interactive ls22