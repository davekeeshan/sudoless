MAKEINFO_REPO     := https://github.com/bminor/makeinfo.git
MAKEINFO_REV      ?= makeinfo-5.1
MAKEINFO_INSTALL  := ${INSTALL_DIR}/makeinfo/${MAKEINFO_REV}
MAKEINFO_DIR      := ${DOWNLOAD_DIR}/makeinfo-git

makeinfo_clean:
	rm -rf $(MAKEINFO_INSTALL)
    
makeinfo: mkdir_install gcc make | $(MAKEINFO_INSTALL)

${MAKEINFO_DIR}:
	@echo "Folder ${MAKEINFO_INSTALL} does not exist"
	git clone ${MAKEINFO_REPO} ${MAKEINFO_DIR}


${MAKEINFO_INSTALL}: | ${MAKEINFO_DIR}
	@echo "Folder ${MAKEINFO_INSTALL} does not exist"
	if [ "${MAKEINFO_REV}" = "" ]; then \
		cd ${MAKEINFO_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${MAKEINFO_DIR}; \
			git fetch; \
        	git checkout -f ${MAKEINFO_REV};\
    fi
	mkdir -p ${MAKEINFO_DIR}
	cd ${MAKEINFO_DIR}; \
		./configure --prefix=${MAKEINFO_INSTALL} ; \
		make clean; \
		make; \
		make install
