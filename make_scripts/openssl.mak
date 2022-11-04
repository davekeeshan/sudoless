OPENSSL_REPO       := https://github.com/openssl/openssl.git
OPENSSL_REV        ?= openssl-3.0.7
OPENSSL_INSTALL    := ${INSTALL_DIR}/openssl/${OPENSSL_REV}
OPENSSL_DIR        := ${DOWNLOAD_DIR}/openssl-git

openssl_clean:
	rm -rf $(OPENSSL_INSTALL)

openssl: mkdir_install gcc make perl | ${OPENSSL_INSTALL}

${OPENSSL_DIR}: 
	@echo "Folder ${OPENSSL_DIR} does not exist"
	git clone ${OPENSSL_REPO} ${OPENSSL_DIR}

${OPENSSL_INSTALL}: | ${OPENSSL_DIR}
	@echo "Folder ${OPENSSL_INSTALL} does not exist"
	if [ "${OPENSSL_REV}" = "" ]; then \
		cd ${OPENSSL_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${OPENSSL_DIR}; \
			git fetch; \
        	git checkout -f ${OPENSSL_REV};\
    fi
	cd ${OPENSSL_DIR} ; \
		./config --prefix=${OPENSSL_INSTALL}; \
		make clean; \
		make; \
		make install; \
        ln -s ${OPENSSL_INSTALL}/lib64 ${OPENSSL_INSTALL}/lib 
	$(MAKE) openssl_link

openssl_link:
	ln -fs $(shell ls ${OPENSSL_INSTALL}/lib/lib*.so*) ${INSTALL_DIR}/local/lib/.