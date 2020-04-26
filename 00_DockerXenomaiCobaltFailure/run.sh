#!/bin/bash

docker-compose -f compose.yml run --service-ports --name xenomai dev-image bash