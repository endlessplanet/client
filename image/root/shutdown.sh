#!/bin/sh

ls -1 ${HOME}/docker/containers | while read ID
do
    sudo --preserve-env /usr/local/bin/docker container stop $(cat ${HOME}/docker/containers/${ID}) &&
        sudo --preserve-env /usr/local/bin/docker container rm --force --volumes $(cat ${HOME}/docker/containers/${ID})
done &&
    ls -1 ${HOME}/docker/networks | while read ID
    do
        sudo --preserve-env /usr/local/bin/docker network rm $(cat ${HOME}/docker/networks/${ID})
    done
