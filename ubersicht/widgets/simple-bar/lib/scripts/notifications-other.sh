#!/bin/bash
./simple-bar/lib/scripts/notifications-other.py3 | tr "'" '"' | /usr/local/bin/jq '."'"$1"'"' | sed 's/"//g' | sed 's/null//'
