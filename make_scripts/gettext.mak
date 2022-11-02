GETTEXT_REPO     := https://github.com/autotools-mirror/gettext.git
GETTEXT_REV      ?= v0.20
GETTEXT_INSTALL  := ${INSTALL_DIR}/gettext/${GETTEXT_REV}
GETTEXT_DIR      := ${DOWNLOAD_DIR}/gettext-git

gettext_clean:
	rm -rf $(GETTEXT_INSTALL)
    
gettext: mkdir_install gcc make gperf | $(GETTEXT_INSTALL)

${GETTEXT_DIR}:
	@echo "Folder ${GETTEXT_INSTALL} does not exist"
	git clone ${GETTEXT_REPO} ${GETTEXT_DIR}


${GETTEXT_INSTALL}: | ${GETTEXT_DIR}
	@echo "Folder ${GETTEXT_INSTALL} does not exist"
	if [ "${GETTEXT_REV}" = "" ]; then \
		cd ${GETTEXT_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${GETTEXT_DIR}; \
			git fetch; \
        	git checkout -f ${GETTEXT_REV};\
    fi
	mkdir -p ${GETTEXT_DIR}
	cd ${GETTEXT_DIR}; \
		export PATH=${GPERF_INSTALL}/bin:${TEXINFO_INSTALL}/bin:${PATH}; \
		./autogen.sh ; \
		./configure --prefix=${GETTEXT_INSTALL} ; \
		make clean; \
		make; \
		make install
