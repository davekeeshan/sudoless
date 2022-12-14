#!/usr/bin/bash
sudo dnf update -y
sudo dnf install make tigervnc-server -y
sudo dnf groupinstall 'Development Tools' -y
#sudo dnf install perl-IPC-Cmd perl-Pod-Html -y
sudo dnf install libX11-devel-1.6.8-5.el8.x86_64 -y

sudo dnf install autoconf automake python3 libmpc-devel mpfr-devel gmp-devel gawk bison flex patchutils gcc gcc-c++ zlib-devel expat-devel -y
sudo dnf install texinfo -y

./setup_groups.sh