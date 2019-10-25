# autodl-curl-sonarr and autodl-curl-radarr
Script to use as upload-command for autodl-irssi to post torrents to Sonarr and Radarr.

Obviously you will need [autodl-irssi](https://github.com/autodl-community), [Sonarr](https://sonarr.tv/) and/or [Radarr](https://radarr.video/) installed for this to work. You will also need curl.

Download autodl-curl-sonarr.sh and/or autodl-curl-radarr.sh and put it wherever you want. You may need to edit the address for Sonarr/Radarr, by default it is `localhost:port`. See https://github.com/Sonarr/Sonarr/wiki/API. Make the script executable for the user running autodl-irssi.

Set up your `autodl.cfg` to include something like this, either in the global `[options]` header or for specific `[filter]` sections as you see fit. Update the path to the script and API_KEY to the values for your system:

```
upload-type = exec
upload-command = /path/to/autodl-curl-sonarr.sh
upload-args = "$(TorrentName)" "$(TorrentUrl)" API_KEY
```
You can set up autodl-irssi filters to simply match everything and let Sonarr decide what it should download based upon your Sonarr configuration.

Optionally you can set the indexer which we recommend doing under `[filter]`:

```
[filter All BTN to Sonarr]
match-sites = btn
upload-command = /home/savagecore/scripts/autodl-curl-sonarr.sh
upload-args = "$(TorrentName)" "$(TorrentUrl)" API_KEY "BroadcastheNet"
upload-type = exec
```

Note on lidarr support: Lidarr needs api/v1/push/release rather than just api/push/release like radarr/sonarr.
