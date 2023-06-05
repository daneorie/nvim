#!/bin/bash

database="$(lsof -p "$(ps aux | grep -m1 usernoted | awk '{ print $2 }')" | awk '{ print $NF }' | grep 'db2/db$')"
count="$(echo "SELECT badge FROM app WHERE identifier = '$1';" | sqlite3 "$database")"

echo "$count"
