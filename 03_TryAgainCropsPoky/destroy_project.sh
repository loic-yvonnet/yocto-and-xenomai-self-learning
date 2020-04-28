#!/bin/bash

# Remove all docker containers
docker ps --all --quiet | xargs docker rm

# Remove the docker image
docker rmi crops/poky:ubuntu-18.04

# Delete the work directory
rm -rf $PWD/workdir
