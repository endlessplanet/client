#!/bin/sh

if [ ! -d ${HOME}/.ssh ]
then
    mkdir ${HOME}/.ssh &&
        chmod 0700 ${HOME}/.ssh
fi &&
    if [ ! -d ${HOME}/.ssh/id_rsa ]
    then
        echo "${ID_RSA}" > ${HOME}/.ssh/id_rsa &&
            chmod 0600 ${HOME}/.ssh/id_rsa
    fi &&
    if [ ! -d ${HOME}/.ssh/known_hosts ]
    then
        echo "${KNOWN_HOSTS}" > ${HOME}/.ssh/known_hosts &&
            chmod 0600 ${HOME}/.ssh/known_hosts
    fi &&
    docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
    docker pull endlessplanet/registry &&
    bash