OPENSSH_REPO     := https://github.com/openssh/openssh-portable.git
OPENSSH_REV      ?= V_9_0_P1
OPENSSH_INSTALL  := ${INSTALL_DIR}/openssh/${OPENSSH_REV}
OPENSSH_DIR      := ${DOWNLOAD_DIR}/openssh-git

openssh_clean:
	rm -rf $(OPENSSH_INSTALL)
    
openssh: mkdir_install make | $(OPENSSH_INSTALL)

${OPENSSH_DIR}:
	@echo "Folder ${OPENSSH_INSTALL} does not exist"
	git clone ${OPENSSH_REPO} ${OPENSSH_DIR}

${OPENSSH_INSTALL}: | ${OPENSSH_DIR}
	@echo "Folder ${OPENSSH_INSTALL} does not exist"
	if [ "${OPENSSH_REV}" = "" ]; then \
		cd ${OPENSSH_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${OPENSSH_DIR}; \
			git fetch; \
        	git checkout -f ${OPENSSH_REV};\
    fi
	mkdir -p ${OPENSSH_DIR}
	cd ${OPENSSH_DIR}; \
		which gcc ; \
		which cc ; \
		autoreconf; \
		./configure --prefix=${OPENSSH_INSTALL} --with-ssl-dir=${OPENSSL_INSTALL} --without-openssl-header-check; \
		make clean; \
		make -j ${PROCESSOR} ; \
		make install
	#$(MAKE) openssh_link

openssh_link:
	ln -fs $(shell ls ${OPENSSH_INSTALL}/bin/*) ${INSTALL_DIR}/local/bin/.
#		./configure --prefix=${OPENSSH_INSTALL} --with-ssl-dir=${OPENSSL_INSTALL}/include --without-openssl-header-check; \
