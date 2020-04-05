#!/bin/bash
#
# https://github.com/Aniverse/qbittorrent-nox-static
# Author: Aniverse
script_update=2020.04.05
script_version=r10010
################################################################################################

usage_guide() {
yum install -y nano        # wget
pacman -S --noconfirm nano # wget

s=$HOME/install.sh;rm -f $s;nano $s;chmod 755 $s
bash $HOME/install.sh aaa bbb 2021 9005

bash <(wget -qO- --no-check-certificate https://github.com/Aniverse/qbittorrent-nox-static/raw/master/install.sh -o /dev/null) aniverse test123
bash <(curl -Ls https://github.com/Aniverse/qbittorrent-nox-static/raw/master/install.sh) aniverse test123
}
################################################################################################

iUser=$1
iPass=$2
webport=$3
iport=$4
qbver=$5
[[ -z $iUser ]] && echo -e "Work in progress, do not use this script for now ..." && exit
[[ -z $iPass ]] && echo -e "Please input your password" && exit 1
[[ -z $webport ]] && webport=2017
[[ -z $iport ]] && iport=9002
[[ -z $qbver ]] && qbver=4.2.3.lt.1.1.14

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

if [[ -n $(command -v wget) ]]; then
    source <(wget -qO- --no-check-certificate https://github.com/Aniverse/inexistence/raw/master/00.Installation/function)
    source <(wget -qO- --no-check-certificate https://github.com/Aniverse/inexistence/raw/master/00.Installation/check-sys)
    serverip=$(wget --no-check-certificate -t1 -T6 -qO- v4.ipv6-test.com/api/myip.php)
elif [[ -n $(command -v curl) ]]; then
    source <(curl -Ls https://github.com/Aniverse/inexistence/raw/master/00.Installation/function)
    source <(curl -Ls https://github.com/Aniverse/inexistence/raw/master/00.Installation/check-sys)
    serverip=$(curl -s v4.ipv6-test.com/api/myip.php)
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
    wget --no-check-certificate https://sourceforge.net/projects/inexistence/files/qbittorrent/qbittorrent-nox.${qbver}/download -O $AppExec >> $OutputLOG 2>&1
    chmod +x $AppExec >> $OutputLOG 2>&1
    status_lock=$AppName
    echo "status_lock=$status_lock" > $tmp_dir/Variables
    rm -f $tmp_dir/$status_lock.1.lock $tmp_dir/$status_lock.2.lock 
    [[ -x $AppExec ]] && touch $tmp_dir/$status_lock.1.lock || $tmp_dir/$status_lock.2.lock
}

function configure_qbittorrent_nox(){
    if [[ $Root == 1 ]]; then
        if [[ $os =~ (debian|ubuntu) ]]; then
            adduser --gecos "" $iUser --disabled-password --force-badname >> $OutputLOG 2>&1
        elif [[ $os == archlinux ]]; then
            useradd $iUser -m  >> $OutputLOG 2>&1
        elif [[ $os == centos ]]; then
            adduser $iUser >> $OutputLOG 2>&1
        else
            useradd $iUser -m  >> $OutputLOG 2>&1
        fi
        echo "$iUser:$iPass" | chpasswd >> $OutputLOG 2>&1
        bash <(wget -qO- --no-check-certificate https://github.com/Aniverse/inexistence/raw/master/00.Installation/package/qbittorrent/configure -o /dev/null) -u $iUser -p $iPass -w $webport -i $iport
        echo -e "\n${cyan}qBittorrent WebUI${normal} http://$serverip:$webport\n"
    else
        wget --no-check-certificate https://github.com/Aniverse/inexistence/raw/master/00.Installation/package/qbittorrent/configure -O ${BinPath}/qbconf >> $OutputLOG 2>&1
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
