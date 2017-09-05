#!/bin/sh

CID_FILE=$(mktemp ${HOME}/docker/containers/XXXXXXXX) &&
    rm -f ${CID_FILE} &&
    sudo --preserve-env docker container create --cidfile ${CID_FILE} --privileged docker:edge "${@}" &&
    sudo --preserve-env docker network connect --link docker $(cat ${HOME}/docker/networks/default) $(cat ${CID_FILE}) &&
    sudo --preserve-env docker container start --interactive $(cat ${CID_FILE})