#!/bin/sh

apk update &&
    apk upgrade &&
    adduser -D user &&
    apk add --no-cache sudo &&
    cp /opt/docker/user.sudo /etc/sudoers.d/user &&
    chmod 0444 /etc/sudoers.d/user &&
    apk add --no-cache docker &&
    apk add --no-cache openssl &&
    apk add --no-cache bash &&
    apk add --no-cache git &&
    apk add --no-cache openssh-client &&
    mkdir /home/user/projects &&
    mkdir /home/user/projects/registry &&
    git -C /home/user/projects/registry init &&
    git -C /home/user/projects/registry config user.name "${USERNAME}" &&
    git -C /home/user/projects/registry config user.email "${EMAIL}" &&
    git -C /home/user/projects/registry remote add origin git@github.com:endlessplanet/registry.git
    chown -R user:user /home/user/projects &&
    mkdir /home/user/docker &&
    mkdir /home/user/docker/containers &&
    mkdir /home/user/docker/networks &&
    chown -R user:user /home/user/docker &&
    rm -rf /var/cache/apk/*