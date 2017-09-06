#!/bin/sh

sh /opt/docker/setup-docker.sh &&
    sh /opt/docker/docker.sh login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
    sh /opt/docker/docker.sh image pull alpine:3.4 &&
    sh /opt/docker/docker.sh image tag alpine:3.4 registry:443/it/my-alpine3:1 &&
    sh /opt/docker/docker.sh login --username user --password password https://registry:443 &&
    sh /opt/docker/docker.sh image push registry:443/it/my-alpine3:1 &&
    sh /opt/docker/docker.sh docker image ls &&
    sh /opt/docker/docker.sh docker image rm alpine:3.4 registry:443/it/my-alpine3:1 &&
    sh /opt/docker/docker.sh image pull registry:443/it/my-alpine3:1 &&
    sh /opt/docker/docker.sh docker image ls