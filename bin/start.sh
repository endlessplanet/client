#!/bin/sh

export NETWORK="${1}" &&
    docker \
        container \
        run \
        --interactive \
        --tty \
        --rm \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        --network ${NETWORK} \
        --env NETWORK \
        endlessplanet/client