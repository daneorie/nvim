#!/bin/bash
export PYTHONPATH="/usr/local/lib/python3.11/site-packages/"
./simple-bar/lib/scripts/notifications-other.py3 | tr "'" '"' | /usr/local/bin/jq '."'"$1"'"' | sed 's/"//g'
