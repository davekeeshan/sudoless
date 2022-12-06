#AUTOMAKE_REPO         := https://github.com/autotools-mirror/automake.git
AUTOMAKE_REPO         := git@github.com:autotools-mirror/automake.git
AUTOMAKE_REV          ?= v1.16.5
AUTOMAKE_INSTALL      := ${INSTALL_DIR}/automake/${AUTOMAKE_REV}
AUTOMAKE_DIR          := ${DOWNLOAD_DIR}/automake-git

automake_clean:
	rm -rf ${AUTOMAKE_INSTALL}

automake: mkdir_install gcc make perl autoconf texinfo | ${AUTOMAKE_INSTALL}

${AUTOMAKE_DIR}: 
	@echo "Folder ${AUTOMAKE_DIR} does not exist"
	git clone ${AUTOMAKE_REPO} ${AUTOMAKE_DIR}

${AUTOMAKE_INSTALL}: | ${AUTOMAKE_DIR}
	@echo "Folder ${AUTOMAKE_INSTALL} does not exist"
	if [ "${AUTOMAKE_REV}" = "" ]; then \
		cd ${AUTOMAKE_DIR}; \
			git pull; \
        	git checkout master;\
	else \
		cd ${AUTOMAKE_DIR}; \
			git pull; \
        	git checkout ${AUTOMAKE_REV};\
    fi
	cd ${AUTOMAKE_DIR}; \
		export PATH=${AUTOCONF_INSTALL}/bin:${TEXINFO_INSTALL}/bin:${PATH}; \
		./bootstrap; \
		./configure --prefix=${AUTOMAKE_INSTALL}; \
		make clean; \
		make -j ${PROCESSOR}; \
		make install;

