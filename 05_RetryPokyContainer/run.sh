#!/bin/bash

#docker exec -w /workdir -u pokyuser -i yocto-dev bash < internal_docker_run.sh
docker exec -w /workdir -u pokyuser -it yocto-dev /workdir/run.sh
