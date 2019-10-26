#!/bin/bash

pvr=$1
title=$2
downloadUrl=$3
date=$(date -u +"%Y-%m-%d %H:%M:%SZ")
indexer=$4
apiUrl="null"
apiKey="null"

post_release() {
    {
        /usr/bin/curl -i -H "Accept: application/json" -H "Content-Type: application/json" -H "X-Api-Key: $apiKey" -X POST -d "$1" $apiUrl
    } &>/dev/null
}

get_api_url() {
    if [ -z "$pvr" ]; then
        echo 'No PVR set'
        exit
    fi

    if [ "$pvr" == "lidarr" ]; then
        apiUrl="http://localhost:8686/api/v1/release/push"
    elif [ "$pvr" == "radarr" ]; then
        apiUrl="http://localhost:7878/api/release/push"
    elif [ "$pvr" == "sonarr" ]; then
        apiUrl="http://localhost:8989/api/release/push"
    fi
}

get_api_key() {
    if [ ! -r "keys/$pvr.key" ]; then
        echo "keys/$pvr.key does not exist or is not readable"
        exit 1
    fi
    apiKey=$(<keys/$pvr.key)
}

get_api_url

get_api_key

if [ -z "$indexer" ]; then
    post_release '{"title":"'"$title"'","downloadUrl":"'"$downloadUrl"'","protocol":"torrent","publishDate":"'"$date"'"}'
    exit
fi

post_release '{"title":"'"$title"'","downloadUrl":"'"$downloadUrl"'","protocol":"torrent","publishDate":"'"$date"'","indexer":"'"$indexer"'"}'
