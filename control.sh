#!/bin/bash
if [ "$1" = "init" ]; then
    if [ -f "./db/minitwit_dev.db" ]; then
        echo "Database already exists."
        exit 1
    fi
    echo "Putting a database to ./db/minitwit_dev.db..."
    sqlite3 ./db/minitwit_dev.db < ./schema.sql
elif [ "$1" = "start" ]; then
    echo "Starting minitwit..."
    nohup bundle exec ruby myapp.rb > ./log/test.log 2>&1 &
elif [ "$1" = "stop" ]; then
    echo "Stopping minitwit..."
    pkill -f minitwit
elif [ "$1" = "inspectdb" ]; then
    ./flag_tool -i | less
elif [ "$1" = "flag" ]; then
    ./flag_tool "$@"
elif [ "$1" = "console" ]; then
    bundle exec irb -I . -r myapp.rb
else
  echo "I do not know this command..."
fi


