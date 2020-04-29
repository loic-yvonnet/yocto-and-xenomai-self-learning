#!/bin/bash

ps -eo pid,comm | grep qemu-system-x86 | tr -d ' ' | sed s/qemu-system-x86//g | xargs kill -9
