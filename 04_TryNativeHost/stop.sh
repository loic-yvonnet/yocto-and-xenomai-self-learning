#!/bin/bash

ps -ef | grep runqemu | cut -d" " -f2 | xargs kill -9 > /dev/null 2>&1
ps -ef | grep qemux | cut -d" " -f2 | xargs kill -9 > /dev/null 2>&1
