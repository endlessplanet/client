#!/bin/sh

export NETWORK="${3}" &&
    docker \
        container \
        run \
        --interactive \
        --tty \
        --rm \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        --workdir /home/user \
        --network ${NETWORK} \
        --env NETWORK \
        --env USERNAME="${1}" \
        --env EMAIL="${2}" \
        --env ID_RSA="$(cat ~/.ssh/id_rsa)" \
        --env KNOWN_HOSTS="$(cat ~/.ssh/known_hosts)" \
        endlessplanet/client