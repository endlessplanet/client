#!/bin/sh

apk update &&
    apk upgrade &&
    adduser -D user &&
    apk add --no-cache docker &&
    apk add --no-cache openssl &&
    apk add --no-cache bash &&
    apk add --no-cache util-linux &&
    apk add --no-cache sudo &&
    cp /opt/docker/user.sudo /etc/sudoers.d/user &&
    chmod 0444 /etc/sudoers.d/user &&
    mkdir /home/user/certificates &&
    chown user:user /home/user/certificates &&
    mkdir /home/user/bin &&
    cp /opt/docker/docker.sh /home/user/bin/docker &&
    chmod 0500 /home/user/bin/docker &&
    chown -R user:user /home/user/bin
    rm -rf /var/cache/apk/*