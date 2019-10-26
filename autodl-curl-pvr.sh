#!/bin/bash

pvr=$1
title=$2
downloadUrl=$3
date=$(date -u +"%Y-%m-%d %H:%M:%SZ")
indexer=$4
apiUrl="null"
apiKey="null"
lidarrBaseUrl="http://localhost:8686"
radarrBaseUrl="http://localhost:7878"
sonarrBaseUrl="http://localhost:8989"

post_release() {
    {
        /usr/bin/curl -i -H "Accept: application/json" -H "Content-Type: application/json" -H "X-Api-Key: $apiKey" -X POST -d "$1" $apiUrl
    } &>/dev/null
}

check_base_url() {
    if [ -r "base-urls.cfg" ]; then
        source base-urls.cfg
        if [ ! -z "$lidarr" ]; then
            lidarrBaseUrl=$lidarr
        fi
        if [ ! -z "$radarr" ]; then
            radarrBaseUrl=$radarr
        fi
        if [ ! -z "$sonarr" ]; then
            sonarrBaseUrl=$sonarr
        fi
    fi
}

get_api_url() {
    if [ -z "$pvr" ]; then
        echo 'No PVR set'
        exit
    fi

    if [ "$pvr" == "lidarr" ]; then
        apiUrl="$lidarrBaseUrl/api/v1/release/push"
    elif [ "$pvr" == "radarr" ]; then
        apiUrl="$radarrBaseUrl/api/release/push"
    elif [ "$pvr" == "sonarr" ]; then
        apiUrl="$sonarrBaseUrl/api/release/push"
    fi
}

get_api_key() {
    if [ ! -r "keys/$pvr.key" ]; then
        echo "keys/$pvr.key does not exist or is not readable"
        exit 1
    fi
    apiKey=$(<keys/$pvr.key)
}

get_api_key

check_base_url

get_api_url

if [ -z "$indexer" ]; then
    post_release '{"title":"'"$title"'","downloadUrl":"'"$downloadUrl"'","protocol":"torrent","publishDate":"'"$date"'"}'
    exit
fi

post_release '{"title":"'"$title"'","downloadUrl":"'"$downloadUrl"'","protocol":"torrent","publishDate":"'"$date"'","indexer":"'"$indexer"'"}'
