# autodl-curl-pvr

> Script to use as upload-command for autodl-irssi to post torrents to Lidarr, Radarr or Sonarr.

## Prerequisites

[autodl-irssi](https://github.com/autodl-community), `curl` and one of the [supported](#supported-pvrs) PVRs

## Install

```
$ wget https://github.com/SavageCore/autodl-curl-pvr/raw/master/autodl-curl-pvr.sh
$ chmod +x autodl-curl-pvr.sh
```

## Usage

> ⚠️ Take note of the first argument as that is required, possible values [below](#supported-pvrs) ⚠️

Configure `autodl.cfg` either as a global `[options]`:

```bash
upload-type = exec
upload-command = /home/savagecore/autodl-curl-pvr.sh
upload-args = "radarr" "$(TorrentName)" "$(TorrentUrl)"
```

or `[filter]`:

```
[filter All BTN to Sonarr]
match-sites = btn
upload-command = /home/savagecore/autodl-curl-pvr.sh
upload-args = "sonarr" "$(TorrentName)" "$(TorrentUrl)" "BroadcastheNet"
upload-type = exec
```

The above example sends all uploads from BroadcastheNet to Sonarr which will then decide whether to snatch or not.

## Supported PVRs

| PVR                             | Argument   | Docs                                      |
| ------------------------------- | ---------- | ----------------------------------------- |
| [Lidarr](https://lidarr.audio/) | `"lidarr"` | https://github.com/Lidarr/Lidarr/wiki/API |
| [Radarr](https://radarr.video/) | `"radarr"` | https://github.com/Radarr/Radarr/wiki/API |
| [Sonarr](https://sonarr.tv/)    | `"sonarr"` | https://github.com/Sonarr/Sonarr/wiki/API |
