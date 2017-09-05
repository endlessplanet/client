#!/bin/sh

docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
    docker pull endlessplanet/registry &&
    bash