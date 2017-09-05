#!/bin/sh

docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
    docker pull endlessplanet/registry &&
    docker network create special &&
    docker container --name registry --env KEY --env CERT endlessplanet/registry &&
    docker network connect --alias registry special registry &&
    docker container start registry &&
    docker image pull alpine:3.4 &&
    docker image tag alpine:3.4 registry/my-alpine2:1 &&
    docker push registry/my-alpine2:1
    bash