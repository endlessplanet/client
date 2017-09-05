#!/bin/sh

apk update &&
    apk upgrade &&
    adduser -D user &&
    apk add --no-cache docker &&
    apk add --no-cache openssl &&
    apk add --no-cache bash &&
    apk add --no-cache git &&
    apk add --no-cache openssh-client &&
    apk add --no-cache util-linux &&
    mkdir /home/user/projects &&
    mkdir /home/user/projects/registry &&
    git -C /home/user/projects/registry init &&
    git -C /home/user/projects/registry remote add origin git@github.com:endlessplanet/registry.git
    chown -R user:user /home/user/projects &&
    rm -rf /var/cache/apk/*