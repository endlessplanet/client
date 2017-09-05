#!/bin/sh

trap /usr/local/bin/shutdown.sh SIGTERM &&
    sudo --preserve-env /usr/local/bin/docker network create $(uuidgen) > ${HOME}/docker/networks/default &&
        sudo --preserve-env \
            /usr/local/bin/docker \
            container \
            create \
            --cidfile ${HOME}/docker/containers/dind \
            --privileged \
            docker:17.07.0-ce-dind \
            --host tcp://0.0.0.0:2376 &&
    sudo --preserve-env docker network connect --link docker $(cat ${HOME}/docker/networks/default) $(cat ${HOME}/docker/containers/dind)
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
    if [ ! -d ${HOME}/certs ]
    then
            mkdir ${HOME}/certs
    fi &&
    if [ ! -f ${HOME}/certs/registry.key ] || [ ! -f ${HOME}/certs/registry.crt ]
    then
        openssl req -x509 -newkey rsa:4096 -keyout ${HOME}/certs/domain.key -out ${HOME}/certs/domain.crt -days 365 -nodes <<EOF
US
Virginia
Arlington
Endless Planet
Heavy Industries
registry




EOF
    fi &&
    sudo mkdir /etc/ca-certificates/registry:5000/ &&
    bash