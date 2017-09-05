#!/bin/sh

apk update &&
    apk upgrade &&
    adduser -D user &&
    apk add --no-cache sudo &&
    cp /opt/docker/user.sudo /etc/sudoers.d/user &&
    chmod 0444 /etc/sudoers.d/user &&
    apk add --no-cache docker &&
    apk add --no-cache bash &&
    rm -rf /var/cache/apk/*