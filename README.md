# qbittorrent-nox-static

This repo contains a build script for `qbittorent-nox` to create a fully static automatically using the current releases of the main dependencies, and an install script for installing `qbittorent-nox` to your seedbox.

## Installation (WIP)

This script can install my pre-built static qbittorrent-nox to your seedbox. Both dedicated servers and shared seedboxes are supported. Running script with root privilege will install qbittorrent to `/usr/bin/qbittorrent-nox`, while without root it will be installed to `$HOME/.local/bin/qbittorrent-nox`.

This script will also setup configuration, including systemd service and WebUI password.

```shell
bash <(wget -qO- https://github.com/Aniverse/qbittorrent-nox-static/raw/master/install.sh)
```

## Download

My qBittorrent static builds can be downloaded [here](https://sourceforge.net/projects/inexistence/files/qbittorrent/).

*qBittorrent was built with the following details:*

```
Arch: amd64 (x86_64)
OS: Debian 10 (buster)
Qt: 5.14.1
Libtorrent: 1.1.4.0
Boost: 1.72.0
OpenSSL: 1.1.1d
zlib: 1.2.11
```

## Credits

https://github.com/userdocs/qbittorrent-nox-static

https://gist.github.com/notsure2/f8eac873eb7298d89d551047779d8361