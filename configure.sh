#!/bin/bash
#
# This file is part of the VSS-SDK project.
#
# This Source Code Form is subject to the terms of the GNU GENERAL PUBLIC LICENSE.txt,
# v. 3.0. If a copy of the GPL was not distributed with this
# file, You can obtain one at http://www.gnu.org/licenses/gpl-3.0/.
#

DISTRO=``
RELEASE=``
RELEASE_DEBIAN=``
ARCHITECTURE=``
COMPILE_TYPE=$1

INSTALLED=0

CMAKE () {
    rm -R build
    mkdir -p build
    cd build
    cmake ..
    make
    cd ..
}

CMAKE_INSTALL () {
    rm -R build
    mkdir -p build
    cd build
    cmake -D RELEASE=ON ..
    make install
    cd ..
}

INSTALL_UBUNTU_18_04 () {
    apt-get update && apt-get upgrade
    apt-get -y install pkg-config
    apt-get -y install libbullet-dev
    INSTALLED=1
}

INSTALL_UBUNTU_16_04 () {
    apt-get update && apt-get upgrade
    apt-get -y install pkg-config
    apt-get -y install libbullet-dev
    INSTALLED=1
}

INSTALL_UBUNTU_14_04 () {
    apt-get update && apt-get upgrade
    apt-get -y install pkg-config
    apt-get -y install libbullet-dev
    INSTALLED=1
}

INSTALL_MINT_18_2 () {
    apt-get update && apt-get upgrade
    apt-get -y install pkg-config
    apt-get -y install libbullet-dev
    INSTALLED=1
}

INSTALL_DEBIAN_9 () {
    apt-get update && apt-get upgrade
    apt-get -y install pkgconf
    apt-get -y install libbullet-dev
    INSTALLED=1
}

INSTALL_BASE() {
    apt-get update && apt-get upgrade
    apt-get -y install lsb-release;

    DISTRO=`lsb_release -si`
    RELEASE=`lsb_release -sr`
    RELEASE_DEBIAN=`lsb_release -sr | cut -c1-1`
    ARCHITECTURE=`uname -m`
}

INIT_SUBMODULES() {
    git submodule init;
    git submodule update;
}

INSTALL () {
    INSTALL_BASE;

    # Ubuntu
    if [[ "$DISTRO" == "Ubuntu" ]] ; then
        INSTALL_UBUNTU_18_04;
    fi

    if [[ "$DISTRO" == "Ubuntu" ]] && [[ "$RELEASE" == "16.04" ]]; then
        INSTALL_UBUNTU_16_04;
    fi

    if [[ "$DISTRO" == "Ubuntu" ]] && [[ "$RELEASE" == "14.04" ]]; then
        INSTALL_UBUNTU_14_04;
    fi

    # Debian
    if [[ "$DISTRO" == "Debian" ]] && [[ "$RELEASE_DEBIAN" == "9" ]]; then
        INSTALL_DEBIAN_9;
    fi

    # LinuxMint
    if [[ "$DISTRO" == "LinuxMint" ]] && [[ "$RELEASE" == "18.2" ]]; then
        INSTALL_MINT_18_2;
    fi

    if [[ $INSTALLED == 0 ]]; then
        echo "Sistema Operacional Incompatível";
    fi

    if [[ $INSTALLED == 1 ]]; then
        INIT_SUBMODULES;

        if [[ $COMPILE_TYPE == "development" ]];
        then
            CMAKE;
        else
            CMAKE_INSTALL;
        fi
    fi
}

INSTALL;
