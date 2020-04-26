#!/bin/bash

docker ps --all --quiet | xargs docker rm
docker rmi xenomai:3.1