#!/bin/bash

pvr=$1
title=$2
downloadUrl=$3
apiKey=$4
date=$(date -u +"%Y-%m-%d %H:%M:%SZ")
indexer=$5
apiUrl="null"

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

    if [ "$pvr" == "radarr" ]; then
        apiUrl="http://localhost:7878/api/release/push"
    elif [ "$pvr" == "sonarr" ]; then
        apiUrl="http://localhost:8989/api/release/push"
    fi
}

get_api_url

if [ -z "$indexer" ]; then
    post_release '{"title":"'"$title"'","downloadUrl":"'"$downloadUrl"'","protocol":"torrent","publishDate":"'"$date"'"}'
    exit
fi

post_release '{"title":"'"$title"'","downloadUrl":"'"$downloadUrl"'","protocol":"torrent","publishDate":"'"$date"'","indexer":"'"$indexer"'"}'
