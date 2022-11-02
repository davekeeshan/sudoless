PANDOC_REPO       := https://github.com/jgm/pandoc.git
PANDOC_REV        ?= 2.19.2
PANDOC_INSTALL    := ${INSTALL_DIR}/pandoc/${PANDOC_REV}
PANDOC_DIR        := ${DOWNLOAD_DIR}/pandoc-git

pandoc_clean:
	rm -rf ${PANDOC_INSTALL}

pandoc: mkdir_install stack | ${PANDOC_INSTALL}

${PANDOC_DIR}: 
	@echo "Folder ${PANDOC_DIR} does not exist"
	git clone ${PANDOC_REPO} ${PANDOC_DIR}

${PANDOC_INSTALL}: | ${PANDOC_DIR}
	@echo "Folder ${PANDOC_INSTALL} does not exist"
	if [ "${PANDOC_REV}" = "" ]; then \
		cd ${PANDOC_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${PANDOC_DIR}; \
			git fetch; \
        	git checkout -f ${PANDOC_REV};\
    fi
	cd ${PANDOC_DIR}; \
		export PATH=${STACK_INSTALL}/bin:${PATH}; \
		stack setup; \
		stack install --local-bin-path ${PANDOC_INSTALL}/bin
	$(MAKE) pandoc_link

pandoc_link:
	ln -fs $(shell ls ${PANDOC_INSTALL}/bin/*) ${INSTALL_DIR}/local/bin/.
