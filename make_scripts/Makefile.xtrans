XTRANS_REV       ?= 1.4.0
XTRANS_INSTALL   := ${INSTALL_DIR}/xtrans/${XTRANS_REV}
XTRANS_DIR       := ${DOWNLOAD_DIR}/xtrans-${XTRANS_REV}

xtrans_clean:
	rm -rf ${XTRANS_INSTALL}

xtrans: mkdir_install gcc make | ${XTRANS_INSTALL}

${XTRANS_DIR}:
	@echo "Folder ${XTRANS_DIR} does not exist"
	wget --no-check-certificate -c -P ${DOWNLOAD_DIR} https://www.x.org/releases/individual/lib/xtrans-${XTRANS_REV}.tar.gz
	cd ${DOWNLOAD_DIR}; tar -zxvf xtrans-${XTRANS_REV}.tar.gz

${XTRANS_INSTALL}: | ${XTRANS_DIR}
	@echo "Folder ${XTRANS_INSTALL} does not exist"
	cd ${XTRANS_DIR}; \
		./configure --prefix=${XTRANS_INSTALL} --with-perl; \
		make; \
		make install
