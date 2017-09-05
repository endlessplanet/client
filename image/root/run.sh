#!/bin/sh

apk update &&
    apk upgrade &&
    adduser -D user &&
    apk add --no-cache docker &&
    apk add --no-cache openssl &&
    apk add --no-cache bash &&
    apk add --no-cache util-linux &&
    mkdir /home/user/certificates &&
    chown user:user /home/user/certificates &&
    rm -rf /var/cache/apk/*