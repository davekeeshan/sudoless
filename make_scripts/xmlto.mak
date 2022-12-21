XMLTO_REV        ?= 0.0.28
XMLTO_INSTALL    := ${INSTALL_DIR}/xmlto/${XMLTO_REV}
XMLTO_DIR        := ${DOWNLOAD_DIR}/xmlto-${XMLTO_REV}

xmlto_clean:
	rm -rf ${XMLTO_INSTALL}

xmlto: mkdir_install gcc | ${XMLTO_INSTALL}


${XMLTO_DIR}:
	@echo "Folder ${XMLTO_DIR} does not exist"
	wget --no-check-certificate -c -P ${DOWNLOAD_DIR} https://releases.pagure.org/xmlto/xmlto-${XMLTO_REV}.tar.bz2
	cd ${DOWNLOAD_DIR}; tar -xf xmlto-${XMLTO_REV}.tar.bz2

${XMLTO_INSTALL}:| ${XMLTO_DIR}
	@echo "Folder $(XMLTO_INSTALL) does not exist"
	cd ${XMLTO_DIR}; \
		./configure --prefix=${XMLTO_INSTALL}; \
		make; \
		make install
	rm -rf ${XMLTO_DIR}
