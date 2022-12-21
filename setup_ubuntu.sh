#!/usr/bin/bash
sudo apt update -y
sudo apt install make build-essential -y
sudo apt install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev -y
sudo apt install libx11-dev libxt-dev libmotif-dev libxpm-dev libpcre3-dev -y
sudo apt install tigervnc-standalone-server tigervnc-xorg-extension tigervnc-viewer -y

# sudo apt install device-tree-compiler -y

./setup_groups.sh