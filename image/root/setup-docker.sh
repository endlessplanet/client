#!/bin/sh

docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
    docker volume create auth &&
    docker network create special &&
    sudo mkdir /srv/volumes/auth &&
    docker \
        container \
        create \
        --name dind \
        --privileged \
        docker:17.07.0-ce-dind \
        --host tcp://0.0.0.0:2376 --insecure-registry registry:443 &&
    docker network connect --alias docker special dind &&
    docker container start dind &&
    docker container create --name genpass --interactive --entrypoint htpasswd registry:2.6.2 -Bnb user password &&
    docker container start --interactive genpass | sudo tee /srv/volumes/auth/htpasswd &&
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
    docker \
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
    docker network connect --alias registry special registry &&
    docker container start registry
