FLEX_REPO         := https://github.com/westes/flex.git
FLEX_REV          ?= v2.6.4
FLEX_INSTALL      := ${INSTALL_DIR}/flex/${FLEX_REV}
FLEX_DIR          := ${DOWNLOAD_DIR}/${DOWNLOAD_DIR}/flex-git

flex_clean:
	rm -rf ${FLEX_INSTALL}

flex: mkdir_install gcc make gnulib | ${FLEX_INSTALL}

${FLEX_DIR}: 
	@echo "Folder ${FLEX_DIR} does not exist"
	git clone ${FLEX_REPO} ${FLEX_DIR}

${FLEX_INSTALL}: | ${FLEX_DIR}
	@echo "Folder ${FLEX_INSTALL} does not exist"
	if [ "${FLEX_REV}" = "" ]; then \
		cd ${FLEX_DIR}; \
			git pull; \
        	git checkout master;\
	else \
		cd ${FLEX_DIR}; \
			git pull; \
        	git checkout ${FLEX_REV};\
    fi
	cd ${FLEX_DIR}; \
		export PATH=${GNULIB_INSTALL}/bin:${GETTEXT_INSTALL}/bin:${TINYTEX_INSTALL}/bin/x86_64-linux:${TEXINFO_INSTALL}/bin:${HELP2MAN_INSTALL}/bin:${PATH}; \
		./autogen.sh; \
		./configure --prefix=${FLEX_INSTALL}; \
		make clean; \
		make; \
		make install        
