#! /usr/bin/env bash
#
# https://github.com/Aniverse/qbittorrent-nox-static
# Author: Aniverse
script_update=2020.03.17
script_version=r10002
################################################################################################

usage_guide() {
s=$HOME/install.sh;rm -f $s;nano $s;chmod 755 $s
bash $HOME/install.sh aniverse test123
bash <(wget -qO- https://github.com/Aniverse/qbittorrent-nox-static/raw/master/install.sh) aniverse test123
}
################################################################################################

iUser=$1
iPass=$2
webport=$3
iport=$4
[[ -z $iUser ]] && echo -e "Work in progress, do not use this script for now ..." && exit
[[ -z $webport ]] && webport=2017
[[ -z $iport ]] && iport=9002
serverip=$(wget --no-check-certificate -t1 -T6 -qO- v4.ipv6-test.com/api/myip.php)

################################################################################################

AppName=qBittorrent
shared=1
source <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/function)
set_variables_log_location

################################################################################################



if [[ $EUID != 0 ]]; then
    Root=0
    BinPath=$HOME/.local/bin
    mkdir -p ${BinPath}
else
    Root=1
    BinPath=/usr/bin
fi

function install_qbittorrent_nox_static(){
    wget https://sourceforge.net/projects/inexistence/files/qbittorrent/qbittorrent-nox.4.2.1.lt.1.1.14/download -O ${BinPath}/qbittorrent-nox >> $OutputLOG 2>&1
    chmod +x ${BinPath}/qbittorrent-nox >> $OutputLOG 2>&1
    status_lock=$AppName
    echo "status_lock=$status_lock" > $tmp_dir/Variables
    rm -f $tmp_dir/$status_lock.1.lock $tmp_dir/$status_lock.2.lock 
    [[ -x ${BinPath}/qbittorrent-nox ]] && touch $tmp_dir/$status_lock.1.lock || $tmp_dir/$status_lock.2.lock
}

function configure_qbittorrent_nox(){
    if [[ $Root == 1 ]]; then
        adduser --gecos "" $iUser --disabled-password --force-badname >> $OutputLOG 2>&1
        echo "$iUser:$iPass" | chpasswd >> $OutputLOG 2>&1
        bash <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/package/qbittorrent/configure -o /dev/null) -u $iUser -p $iPass -w $webport -i $iport
        echo -e "http://$serverip:$webport"
    else
        wget https://github.com/Aniverse/inexistence/raw/master/00.Installation/package/qbittorrent/configure -O ${BinPath}/qbconf >> $OutputLOG 2>&1
        chmod +x ${BinPath}/qbconf
    fi
}



################################################################################################




if [[ ! -x ${BinPath}/qbittorrent-nox ]] ; then
    echo_task "Installing $AppName ..."
    install_qbittorrent_nox_static & spinner $!
    check_status $status_lock
fi
configure_qbittorrent_nox
