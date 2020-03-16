# qbittorrent-nox-static

This is a fork of this [repo](https://github.com/userdocs/qbittorrent-nox-static), thanks to [userdocs](https://github.com/userdocs).

This repo contains a build script for `qBittorent-nox` to create a fully static automatically using the current releases of the main dependencies when the script is executed.

I added some personal patches to libtorrent-rasterbar and qBittorrent, and uses libtorrent 1.1.14 instead of libtorrent 1.2 branch.

## Installation (WIP)

This script will install static qbittorrent-nox to your seedbox. Both dedicated servers and shared seedboxes are supported. Running script with root privilege will install qbittorrent to `/usr/bin/qbittorrent-nox`, while without root it will be installed to `$HOME/.local/bin/qbittorrent-nox`.

This script will also configure qbittorrent, including systemd service, webui password.

```shell
bash <(wget -qO- https://github.com/Aniverse/qbittorrent-nox-static/raw/master/XXXX)
```

## Download (WIP)

My qBittorrent static builds can be downloaded [here](https://github.com/Aniverse/qbittorrent-nox-static/releases).

*qBittorrent was built with the following details:*

```
~~~
Arch: amd64
OS: Debian 10 (buster)
Qt: 5.14.1
Libtorrent: 1.1.4.0
Boost: 1.72.0
OpenSSL: 1.1.1d
zlib: 1.2.11
~~~
```

## Credits

https://github.com/userdocs

https://gist.github.com/notsure2