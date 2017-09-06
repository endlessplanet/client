#!/bin/sh

/usr/local/bin/docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
    /usr/local/bin/docker volume create auth &&
    /usr/local/bin/docker network create special &&
    sudo mkdir /srv/volumes/auth &&
    /usr/local/bin/docker \
        container \
        create \
        --name dind \
        --privileged \
        docker:17.07.0-ce-dind \
        --host tcp://0.0.0.0:2376 --insecure-registry registry:443 &&
    /usr/local/bin/docker network connect --alias docker special dind &&
    /usr/local/bin/docker container start dind &&
    /usr/local/bin/docker container create --name genpass --interactive --entrypoint htpasswd registry:2.6.2 -Bnb user password &&
    /usr/local/bin/docker container start --interactive genpass | sudo tee /srv/volumes/auth/htpasswd &&
    sudo mkdir /srv/volumes/certs &&
    (sudo openssl req -x509 -newkey rsa:4096 -keyout /srv/volumes/certs/registry.key  -out /srv/volumes/certs/registry.crt -days 365 -nodes <<EOF
US
Virginia
Arlington
Endless Planet
Heavy Industries
registry




EOF
    ) &&
    sudo chmod 0644 /srv/volumes/certs/registry.crt /srv/volumes/certs/registry.key &&
    /usr/local/bin/docker \
        container \
        create \
        --name registry \
        --volume /srv/volumes/auth:/auth \
        --volume /srv/volumes/certs:/certs \
        --env REGISTRY_HTTP_ADDR=0.0.0.0:443 \
        --env REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt \
        --env REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
        --env REGISTRY_AUTH=htpasswd \
        --env REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm" \
        --env REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
        registry:2.6.2 &&
    /usr/local/bin/docker network connect --alias registry special registry &&
    /usr/local/bin/docker container start registry
