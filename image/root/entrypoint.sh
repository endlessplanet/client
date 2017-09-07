#!/bin/sh

sh /opt/docker/setup-docker.sh &&
    ${HOME}/bin/docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
    ${HOME}/bin/docker image pull alpine:3.4 &&
    ${HOME}/bin/docker image tag alpine:3.4 registry:443/it/my-alpine3:1 &&
    ${HOME}/bin/docker login --username user --password password https://registry:443 &&
    ${HOME}/bin/docker image push registry:443/it/my-alpine3:1 &&
    ${HOME}/bin/docker image ls &&
    ${HOME}/bin/docker image rm alpine:3.4 registry:443/it/my-alpine3:1 &&
    ${HOME}/bin/docker image pull registry:443/it/my-alpine3:1 &&
    ${HOME}/bin/docker image ls &&
    ls -alh /tmp/.X11-unix &&
    echo ${DISPLAY} &&
    echo docker run --interactive --tty --rm --env DISPLAY --volume /tmp/.X11-unix:/tmp/.X11-unix silex/emacs &&
    bash