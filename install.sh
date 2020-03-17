#! /usr/bin/env bash
#
# https://github.com/Aniverse/qbittorrent-nox-static
# Author: Aniverse
script_update=2020.03.17
script_version=r10000
################################################################################################

iUser=$1
iPass=$2
[[ -z $iUser ]] && echo -e "Work in progress, do not use this script for now ..." && exit

if [[ $EUID != 0 ]]; then
    Root=0
    BinPath=$HOME/.local/bin
    mkdir -p ${BinPath}
else
    Root=1
    BinPath=/usr/bin
fi

function install_qbittorrent_nox_static(){
    wget https://sourceforge.net/projects/inexistence/files/qbittorrent/qbittorrent-nox.4.2.1.lt.1.1.14.strip/download -O ${BinPath}/qbittorrent-nox
    chmod +x ${BinPath}/qbittorrent-nox
}

function configure_qbittorrent_nox(){
    if [[ $Root == 1 ]]; then
        adduser --gecos "" $iUser --disabled-password --force-badname
        echo "$iUser:$iPass" | chpasswd
        bash <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/package/qbittorrent/configure) -u $iUser -p $iPass
    else
        wget https://github.com/Aniverse/inexistence/raw/master/00.Installation/package/qbittorrent/configure -O ${BinPath}/qbconf
        chmod +x ${BinPath}/qbconf
    fi
}


install_qbittorrent_nox_static
configure_qbittorrent_nox