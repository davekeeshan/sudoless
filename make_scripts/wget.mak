WGET_REV        ?= 1.21.3
WGET_INSTALL    := ${INSTALL_DIR}/wget/${WGET_REV}
WGET_DIR        := ${DOWNLOAD_DIR}/wget-${WGET_REV}

wget_clean:
	rm -rf ${WGET_INSTALL}

wget: mkdir_install gcc make | ${WGET_INSTALL}

${WGET_DIR}:
	@echo "Folder ${WGET_DIR} does not exist"
	rm -rf wget*
	wget --no-check-certificate https://ftp.gnu.org/gnu/wget/wget-${WGET_REV}.tar.gz
	tar -zxvf wget-${WGET_REV}.tar.gz

${WGET_INSTALL}: | ${WGET_DIR}
	@echo "Folder ${WGET_INSTALL} does not exist"
	cd ${WGET_DIR}; \
		./configure --prefix=${WGET_INSTALL}; \
		make; \
		make install
