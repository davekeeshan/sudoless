GHCLI_REPO       := https://github.com/cli/cli.git
GHCLI_REV        ?= v2.15.0
GHCLI_INSTALL    := ${INSTALL_DIR}/ghcli/${GHCLI_REV}
GHCLI_DIR        := ${DOWNLOAD_DIR}/ghcli-git

ghcli_clean:
	rm -rf ${GHCLI_INSTALL}

ghcli: mkdir_install gcc make | ${GHCLI_INSTALL}

${GHCLI_DIR}: 
	@echo "Folder ${GHCLI_DIR} does not exist"
	git clone ${GHCLI_REPO} ${GHCLI_DIR}

${GHCLI_INSTALL}: | ${GHCLI_DIR}
	@echo "Folder ${GHCLI_INSTALL} does not exist"
	if [ "${GHCLI_REV}" = "" ]; then \
		cd ${GHCLI_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${GHCLI_DIR}; \
			git fetch; \
        	git checkout -f ${GHCLI_REV};\
    fi
	cd ${GHCLI_DIR}; \
		export PATH=${GO_INSTALL}/bin:${PATH}; \
		make clean; \
		make; \
		make install prefix=${GHCLI_INSTALL}
