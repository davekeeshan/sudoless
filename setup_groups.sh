#!/usr/bin/bash
git config --global user.email "dave.keeshan@daxzio.com"
git config --global user.name "Dave Keeshan"

sudo usermod -G sudo ${USER}

NEWGRP=cadtools
sudo groupadd -g 2000 ${NEWGRP}
sudo usermod -G ${NEWGRP} ${USER}
sudo mkdir -p /${NEWGRP}
sudo chgrp -R ${NEWGRP} /${NEWGRP}
sudo chown -R ${USER} /${NEWGRP}
