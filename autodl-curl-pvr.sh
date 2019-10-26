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

log_error() {
    echo "[$(date --rfc-3339=seconds)] $1" >>error.log
}

post_release() {
    status=$(curl --connect-timeout 5 --write-out %{http_code} --silent --output /dev/null -i -H "Accept: application/json" -H "Content-Type: application/json" -H "X-Api-Key: $apiKey" -X POST -d "$1" $apiUrl)
    if [ "$status" == 200 ]; then
        exit 0
    elif [ "$status" == 303 ]; then
        log_error "[FATAL] Error 303 response from API - perhaps you need to setup base-url?"
        exit 1
    elif [ "$status" == 000 ]; then
        log_error "[FATAL] Unable to connect to \"$apiUrl\""
        exit 1
    else
        log_error "[ERROR] Unknown error occured with status $status"
        log_error "curl --connect-timeout 5 --write-out %{http_code} --silent --output /dev/null -i -H \"Accept: application/json\" -H \"Content-Type: application/json\" -H \"X-Api-Key: $apiKey\" -X POST -d \"$1\" $apiUrl"
        exit 1
    fi
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
    check_base_url

    if [ "$pvr" == "lidarr" ]; then
        apiUrl="$lidarrBaseUrl/api/v1/release/push"
    elif [ "$pvr" == "radarr" ]; then
        apiUrl="$radarrBaseUrl/api/release/push"
    elif [ "$pvr" == "sonarr" ]; then
        apiUrl="$sonarrBaseUrl/api/release/push"
    else
        log_error "[FATAL] Unable to determine API URL for \"$pvr\""
        exit 1
    fi
}

get_api_key() {
    if [ ! -r "keys/$pvr.key" ]; then
        log_error "[FATAL] Error reading API Key for \"$pvr\" [keys/$pvr.key]"
        exit 1
    fi
    apiKey=$(<keys/$pvr.key)
}

if [ -z "$pvr" ]; then
    log_error "[FATAL] No PVR set"
    exit 1
fi

get_api_key

get_api_url

if [ -z "$indexer" ]; then
    post_release '{"title":"'"$title"'","downloadUrl":"'"$downloadUrl"'","protocol":"torrent","publishDate":"'"$date"'"}'
    exit 0
fi

post_release '{"title":"'"$title"'","downloadUrl":"'"$downloadUrl"'","protocol":"torrent","publishDate":"'"$date"'","indexer":"'"$indexer"'"}'
