TINYTEX_REPO     := https://github.com/rstudio/tinytex.git
TINYTEX_REV      ?= v0.40
TINYTEX_INSTALL  := ${INSTALL_DIR}/tinytex/${TINYTEX_REV}
TINYTEX_DIR      := ${DOWNLOAD_DIR}/tinytex-git

tinytex_clean:
	rm -rf $(TINYTEX_INSTALL)
    
tinytex: mkdir_install gcc make | $(TINYTEX_INSTALL)

${TINYTEX_DIR}:
	@echo "Folder ${TINYTEX_INSTALL} does not exist"
	git clone ${TINYTEX_REPO} ${TINYTEX_DIR}


${TINYTEX_INSTALL}: | ${TINYTEX_DIR}
	@echo "Folder ${TINYTEX_INSTALL} does not exist"
	if [ "${TINYTEX_REV}" = "" ]; then \
		cd ${TINYTEX_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${TINYTEX_DIR}; \
			git fetch; \
        	git checkout -f ${TINYTEX_REV};\
    fi
	mkdir -p ${TINYTEX_DIR}
	cd ${TINYTEX_DIR}/tools; \
		make clean; \
		make;
	mkdir -p ${TINYTEX_INSTALL}
	cp -r ${TINYTEX_DIR}/tools/texlive/* ${TINYTEX_INSTALL}/.
