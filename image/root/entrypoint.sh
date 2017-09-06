#!/bin/sh

docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
    # docker pull endlessplanet/registry &&
    docker volume create homey &&
    docker volume create certs &&
    docker volume create auth &&
    docker network create special &&
    mkdir ${HOME}/auth &&
    docker run --interactive --tty --rm --entrypoint htpasswd registry:2.6.2 -Bnb user password | docker container run --interactive --rm --volume auth:/auth --workdir /auth alpine:3.4 tee htpasswd &&
    echo "${CERT}" > ${HOME}/certificates/registry.crt &&
    echo "${KEY}" > ${HOME}/certificates/registry.key &&
    chmod 0644 ${HOME}/certificates/registry.crt ${HOME}/certificates/registry.key &&
    cat ${HOME}/certificates/registry.crt | docker container run --interactive --rm --volume certs:/certs --workdir /certs alpine:3.4 tee registry.crt &&
    cat ${HOME}/certificates/registry.key | docker container run --interactive --rm --volume certs:/certs --workdir /certs alpine:3.4 tee registry.key &&
    docker container run --interactive --rm --volume certs:/certs --workdir /certs alpine:3.4 chmod 0644 registry.key registry.crt &&
    docker \
        container \
        create \
        --name registry \
        --publish 5000:5000 \
        --publish 80:443 \
        --publish 443:443 \
        --volume auth:/auth \
        --volume certs:/certs \
        --env REGISTRY_HTTP_ADDR=0.0.0.0:443 \
        --env REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt \
        --env REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
        --env REGISTRY_AUTH=htpasswd \
        --env REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm" \
        --env REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
        registry:2.6.2 &&
    docker network connect --alias registry special registry &&
    docker container start registry &&
    docker image pull alpine:3.4 &&
    docker image tag alpine:3.4 localhost:443/my-alpine2:1 &&
    docker login --username user --password password localhost:443 &&
    docker image push localhost:443/my-alpine2:1 &&
    docker image tag alpine:3.4 registry/it/my-alpine3:1 &&
    docker container create --volume homey:/root --tty --name wtf --volume /var/run/docker.sock:/var/run/docker.sock:ro --entrypoint sh docker:17.07.0-ce &&
    docker network connect special wtf &&
    docker container start wtf &&
    docker container create --volume homey:/root --name login --volume /var/run/docker.sock:/var/run/docker.sock:ro docker:17.07.0-ce login --username user --password password https://registry:443 &&
    docker network connect special login &&
    bash &&
    docker container start --interactive login &&
    docker container create --volume homey:/root --name push-alpine --volume /var/run/docker.sock:/var/run/docker.sock:ro docker:17.07.0-ce image push registry:443/it/my-alpine3:1 &&
    docker network connect special push-alpine &&
    docker container exec -it wtf mkdir /etc/docker &&
    docker container cp /opt/docker/daemon.json wtf:/etc/docker/daemon.json &&
    docker container restart wtf &&
    bash &&
    docker container start --interactive push-alpine &&
    docker image ls &&
    docker image rm alpine:3.4 localhost:443/my-alpine2:1 registry/it/my-alpine3:1 &&
    docker image pull localhost:443/my-alpine2:1 &&
    docker container create --volume homey:/root --name pull-alpine --volume /var/run/docker.sock:/var/run/docker.sock:ro docker:17.07.0-ce image pull registry:443/it/my-alpine3:1 &&
    docker network connect special pull-alpine &&
    docker container start --interactive pull-alpine &&
    docker image ls &&
    bash