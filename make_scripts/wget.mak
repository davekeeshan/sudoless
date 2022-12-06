# make wget GCC_REV=10.4.0
WGET_REV        ?= 1.21.3
WGET_INSTALL    := ${INSTALL_DIR}/wget/${WGET_REV}
WGET_DIR        := ${DOWNLOAD_DIR}/wget-${WGET_REV}
SYSTEM_WGET     ?= 1

ifeq ($(SYSTEM_WGET), 0)
	PATH := $(WGET_INSTALL)/bin:${PATH}
endif

wget_clean:
	rm -rf ${WGET_INSTALL}

wget: mkdir_install gcc make | ${WGET_INSTALL}

${WGET_DIR}:
ifeq (${SYSTEM_WGET}, 0)
	@echo "Folder ${WGET_DIR} does not exist"
	wget --no-check-certificate -c -P ${DOWNLOAD_DIR} https://ftp.gnu.org/gnu/wget/wget-${WGET_REV}.tar.gz
	cd ${DOWNLOAD_DIR} ; tar -zxvf wget-${WGET_REV}.tar.gz
endif

${WGET_INSTALL}: | ${WGET_DIR}
ifeq (${SYSTEM_WGET}, 1)
	@echo "Using System WGET"
else
	$(MAKE) openssl gcc make
	@echo "Folder ${WGET_INSTALL} does not exist"
	cd ${WGET_DIR}; \
		./configure --prefix=${WGET_INSTALL} --with-ssl=openssl --with-openssl=yes -with-libssl-prefix=${OPENSSL_INSTALL}; \
		make -j ${PROCESSOR} ; \
		make install
		$(MAKE) wget_link
endif

wget_link:
	ln -fs $(shell ls ${WGET_INSTALL}/bin/*) ${INSTALL_DIR}/local/bin/.
