#!/usr/bin/env bash

# prevent Windows from converting paths.
export MSYS_NO_PATHCONV=1


trap "docker stop crossbar-test; trap - SIGTERM && kill -- -$$ 2> /dev/null" SIGINT SIGTERM EXIT


docker run --rm --name crossbar-test -p 9091:9091 \
-v "$(pwd)/.crossbar":/node/.crossbar \
crossbario/crossbar:pypy3
