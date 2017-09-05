#!/bin/sh

docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
    # docker pull endlessplanet/registry &&
    docker network create special &&
    docker \
        container \
        create \
        --name registry \
        --publish 5000:5000 \
        registry:2 &&
    docker network connect --alias registry special registry &&
    docker container start registry &&
    docker image pull alpine:3.4 &&
    docker image tag alpine:3.4 localhost:5000/my-alpine3:1 &&
    docker image push localhost:5000/my-alpine3:1 &&
    docker image rm alpine:3.4 localhost:5000/my-alpine3:1 &&
    docker image ls &&
    docker image pull localhost:5000/my-alpine3:1 &&
    docker image ls &&
    # docker image tag alpine:3.4 registry/my-alpine2:1 &&
    # docker image push registry/my-alpine2:1 &&
    bash