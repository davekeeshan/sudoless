GNUTLS_REV        ?= 3.7.6
GNUTLS_INSTALL    := ${INSTALL_DIR}/gnutls/${GNUTLS_REV}
GNUTLS_DIR        := ${DOWNLOAD_DIR}/gnutls-${GNUTLS_REV}

gnutls_clean:
	rm -rf ${GNUTLS_INSTALL}

gnutls: mkdir_install gcc make | ${GNUTLS_INSTALL}

${GNUTLS_DIR}:
	@echo "Folder ${GNUTLS_DIR} does not exist"
	rm -rf gnutls*
	wget --no-check-certificate https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-${GNUTLS_REV}.tar.xz
	tar -xvf gnutls-${GNUTLS_REV}.tar*

${GNUTLS_INSTALL}: | ${GNUTLS_DIR}
	@echo "Folder ${GNUTLS_INSTALL} does not exist"
	cd ${GNUTLS_DIR}; \
		export PATH=${GCC_INSTALL}/bin:${MAKE_INSTALL}/bin:${PATH}; \
		./configure --prefix=${GNUTLS_INSTALL} --with-nettle-mini ; \
		make; \
		#make install
# 	rm -rf gnutls*
