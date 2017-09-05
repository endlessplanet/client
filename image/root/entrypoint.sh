#!/bin/sh

docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
    # docker pull endlessplanet/registry &&
    docker network create special &&
    docker \
        container \
        create \
        --name registry \
        --publish 5000:5000 \
        --publish 80:80 \
        --env REGISTRY_HTTP_ADDR=0.0.0.0:80 \
        --env REGISTRY_HTTP_TLS_CERTIFICATE=/registry.crt \
        --env REGISTRY_HTTP_TLS_KEY=/registry.key \
        registry:2.6.2 &&
    docker network connect --alias registry special registry &&
    echo "${CERT}" > ${HOME}/certificates/registry.crt &&
    echo "${KEY}" > ${HOME}/certificates/registry.key &&
    chmod 0644 ${HOME}/certificates/registry.crt ${HOME}/certificates/registry.key &&
    docker container cp ${HOME}/certificates/registry.crt registry:/registry.crt &&
    docker container cp ${HOME}/certificates/registry.key registry:/registry.key &&
    docker container start registry &&
    docker image pull alpine:3.4 &&
    docker image tag alpine:3.4 localhost:80/my-alpine2:1 &&
    docker image push localhost:80/my-alpine2:1 &&
    docker image tag alpine:3.4 registry/my-alpine3:1 &&
    docker container create --name push-alpine --volume /var/run/docker.sock:/var/run/docker.sock:ro docker:17.07.0-ce image push registry/my-alpine3:1 &&
    docker container start --interactive push-alpine &&
    docker image ls &&
    docker image rm alpine:3.4 localhost:80/my-alpine2:1 registry/my-alpine3:1 &&
    docker image pull localhost:80/my-alpine2:1 &&
    docker container create --name pull-alpine --volume /var/run/docker.sock:/var/run/docker.sock:ro docker:17.07.0-ce image pull registry/my-alpine3:1 &&
    docker container start --interactive pull-alpine &&
    docker image ls &&
    bash