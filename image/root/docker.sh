#!/bin/sh

CID_FILE=$(mktemp ${HOME}/docker/containers/XXXXXXXX) &&
    rm -f ${CID_FILE} &&
    sudo --preserve-env docker --host tcp://docker:2376 container --host tcp:create --cidfile ${CID_FILE} --privileged docker:edge "${@}" &&
    sudo --preserve-env docker --host tcp://docker:2376 network connect --link docker $(cat ${HOME}/docker/networks/default) $(cat ${CID_FILE}) &&
    sudo --preserve-env docker --host tcp://docker:2376 container start --interactive $(cat ${CID_FILE})