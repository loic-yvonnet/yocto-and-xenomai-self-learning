#!/bin/bash

docker exec -w /workdir -u pokyuser -i yocto-dev /workdir/compile.sh
