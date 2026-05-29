#!/bin/bash

# Load url from credential directory
if [ -z "$CREDENTIALS_DIRECTORY" ]; then
    echo "Error: missing CREDENTIALS_DIRECTORY env" >&2
    exit 1
elif ! [ -f "$CREDENTIALS_DIRECTORY/cronitor.url" ]; then
    echo "Error: missing cronitor.url" >&2
    exit 2
else
    URL="$(< "$CREDENTIALS_DIRECTORY/cronitor.url")"
fi

# Retrieve and update counter
counter=0
if [ -z "$RUNTIME_DIRECTORY" ]; then
    echo "Error: missing RUNTIME_DIRECTORY" >&2
    exit 3
elif [ -f "$RUNTIME_DIRECTORY/counter" ]; then
    counter="$(< "$RUNTIME_DIRECTORY/counter")"

    # validate counter
    if ! [[ "$counter" =~ ^[0-9]+$ ]]; then
        echo "Error: counter has invalid value, forcing 0" >&2
        counter=0
    fi

    # increment counter
    (( counter++ ))

    # save new counter
    printf "%s\n" "$counter" > "$RUNTIME_DIRECTORY/counter"
fi

# Retrieve uptime
UPTIME="$(uptime -p)"

# Setting max time
if [ -z "$MAX_TIME" ]; then
    MAX_TIME=60
fi

# Calling curl with parameters
curl --max-time="$MAX_TIME" \
    --silent \
    --get \
    --data-urlencode "msg=uptime: $UPTIME" \
    --data-urlencode "metric=count:$counter" \
    "$URL"