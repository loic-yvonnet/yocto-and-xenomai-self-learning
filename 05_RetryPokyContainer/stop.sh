#!/bin/bash

# Stop all running containers
docker ps --all --quiet | xargs docker stop

# Remove all docker containers
docker ps --all --quiet | xargs docker rm
