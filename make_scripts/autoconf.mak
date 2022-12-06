AUTOCONF_REPO     := git@github.com:autotools-mirror/autoconf.git
AUTOCONF_REV      ?= v2.72a
AUTOCONF_INSTALL  := ${INSTALL_DIR}/autoconf/${AUTOCONF_REV}
AUTOCONF_DIR      := ${DOWNLOAD_DIR}/autoconf-git


autoconf_clean:
	rm -rf $(AUTOCONF_INSTALL)
    
autoconf: mkdir_install gcc make | $(AUTOCONF_INSTALL)
	#export PATH=${AUTOCONF_INSTALL}/bin:${PATH}
	#PATH := ${AUTOCONF_INSTALL}/bin:${PATH}

${AUTOCONF_DIR}:
	@echo "Folder ${AUTOCONF_INSTALL} does not exist"
	git clone ${AUTOCONF_REPO} ${AUTOCONF_DIR}


${AUTOCONF_INSTALL}: | ${AUTOCONF_DIR}
	@echo "Folder ${AUTOCONF_INSTALL} does not exist"
	if [ "${AUTOCONF_REV}" = "" ]; then \
		cd ${AUTOCONF_DIR}; \
			git fetch; \
        		git checkout -f master;\
	else \
		cd ${AUTOCONF_DIR}; \
			git fetch; \
        		git checkout -f ${AUTOCONF_REV};\
	fi
	echo ${PATH}
	cd ${AUTOCONF_DIR}; \
		autoreconf -i  ; \
		./configure --prefix=${AUTOCONF_INSTALL} ; \
		make clean; \
		make -j ${PROCESSOR}; \
		make install
