NETTLE_REPO        := https://github.com/gnutls/nettle.git
NETTLE_REV         ?= nettle_3.8_release_20220602
NETTLE_INSTALL     := ${INSTALL_DIR}/nettle/${NETTLE_REV}
NETTLE_DIR         := ${DOWNLOAD_DIR}/nettle-git

nettle_clean:
	rm -rf ${NETTLE_INSTALL}

nettle: mkdir_install gcc make | ${NETTLE_INSTALL}

${NETTLE_DIR}:
	@echo "Folder ${NETTLE_DIR} does not exist"
	git clone ${NETTLE_REPO} ${NETTLE_DIR}

${NETTLE_INSTALL}: | ${NETTLE_DIR}
	@echo "Folder ${NETTLE_INSTALL} does not exist"
	if [ "${NETTLE_REV}" = "" ]; then \
		cd ${NETTLE_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${NETTLE_DIR}; \
			git fetch; \
        	git checkout -f ${NETTLE_REV};\
    fi
	cd ${NETTLE_DIR}; \
		export PATH=${GCC_INSTALL}/bin:${MAKE_INSTALL}/bin:${GIT_INSTALL}/bin:${PATH}; \
		autoconf; \
		./configure --prefix=${NETTLE_INSTALL} --with-lib-path=${GMP_INSTALL}; \
		make clean; \
		make; \
		#make install
