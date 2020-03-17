#! /usr/bin/env bash
#
# https://github.com/Aniverse/qbittorrent-nox-static
# Author: Aniverse
script_update=2020.03.17
script_version=r10006
################################################################################################

usage_guide() {
s=$HOME/install.sh;rm -f $s;nano $s;chmod 755 $s
bash $HOME/install.sh aaaa bbb 2021 9005

bash <(wget -qO- https://github.com/Aniverse/qbittorrent-nox-static/raw/master/install.sh -o /dev/null) aniverse test123
bash <(curl -Ls https://github.com/Aniverse/qbittorrent-nox-static/raw/master/install.sh) aniverse test123
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

if [[ $EUID != 0 ]]; then
    Root=0
    shared=1
    BinPath=$HOME/.local/bin
    mkdir -p $BinPath
else
    Root=1
    BinPath=/usr/bin
fi

AppName=qBittorrent
AppNameLower=qbittorrent
AppCmd=qbittorrent-nox
AppExec="${BinPath}/${AppCmd}"

if [[ -n $(command -v curl) ]]; then
    source <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/function)
    source <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/check-sys)
elif [[ -n $(command -v curl) ]]; then
    source <(curl -Ls https://github.com/Aniverse/inexistence/raw/master/00.Installation/function)
    source <(curl -Ls https://github.com/Aniverse/inexistence/raw/master/00.Installation/check-sys)
fi
set_variables_log_location
check_var_OutputLOG

################################################################################################


if [[ -z $(command -v wget) ]]; then
    echo -n "Installing wget ... "
    pm_action install wget >> $OutputLOG 2>&1
    echo -e " ${green}${bold}DONE${normal}"
fi

function install_qbittorrent_nox_static(){
    wget https://sourceforge.net/projects/inexistence/files/qbittorrent/qbittorrent-nox.4.2.1.lt.1.1.14/download -O $AppExec >> $OutputLOG 2>&1
    chmod +x $AppExec >> $OutputLOG 2>&1
    status_lock=$AppName
    echo "status_lock=$status_lock" > $tmp_dir/Variables
    rm -f $tmp_dir/$status_lock.1.lock $tmp_dir/$status_lock.2.lock 
    [[ -x $AppExec ]] && touch $tmp_dir/$status_lock.1.lock || $tmp_dir/$status_lock.2.lock
}

function configure_qbittorrent_nox(){
    if [[ $Root == 1 ]]; then
        if [[ $release =~ (debian|ubunt) ]]; then
            adduser --gecos "" $iUser --disabled-password --force-badname >> $OutputLOG 2>&1
        else
            adduser $iUser >> $OutputLOG 2>&1
        fi
        echo "$iUser:$iPass" | chpasswd >> $OutputLOG 2>&1
        bash <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/package/qbittorrent/configure -o /dev/null) -u $iUser -p $iPass -w $webport -i $iport
        echo -e "\n${cyan}qBittorrent WebUI${normal} http://$serverip:$webport\n"
    else
        wget https://github.com/Aniverse/inexistence/raw/master/00.Installation/package/qbittorrent/configure -O ${BinPath}/qbconf >> $OutputLOG 2>&1
        chmod +x ${BinPath}/qbconf
    fi
}


################################################################################################


if [[ ! -x $AppExec ]] ; then
    echo_task "Installing $AppName ..."
    install_qbittorrent_nox_static & spinner $!
    check_status $status_lock
fi
configure_qbittorrent_nox
