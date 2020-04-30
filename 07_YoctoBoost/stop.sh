#!/bin/bash

ps -eo pid,comm | grep qemu-system-aar | tr -d ' ' | sed s/qemu-system-aar//g | xargs kill -9
