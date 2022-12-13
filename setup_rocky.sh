#!/usr/bin/bash
sudo dnf update -y
sudo dnf install make  -y
sudo dnf groupinstall 'Development Tools' -y

./setup_groups.sh