#!/usr/bin/bash
NEWGRP=cadtools
sudo groupadd -g 2000 ${NEWGRP}
sudo usermod -G ${NEWGRP} ${USER}
sudo mkdir -p /${NEWGRP}
sudo chgrp -R ${NEWGRP} /${NEWGRP}
sudo chown -R ${USER} /${NEWGRP}