#!/bin/bash

docker exec -w /workdir -u pokyuser -i yocto-dev bash < internal_docker_compile.sh
