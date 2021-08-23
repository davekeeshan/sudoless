GLIBC_REPO     := https://sourceware.org/git/glibc.git
GLIBC_REV      ?= 2.35
GLIBC_INSTALL  := ${INSTALL_DIR}/glibc/${GLIBC_REV}
GLIBC_DIR      := ${DOWNLOAD_DIR}/glibc-git

glibc_clean:
	rm -rf $(GLIBC_INSTALL)
    
glibc: mkdir_install gcc make | $(GLIBC_INSTALL)

${GLIBC_DIR}:
	@echo "Folder ${GLIBC_INSTALL} does not exist"
	git clone ${GLIBC_REPO} ${GLIBC_DIR}


${GLIBC_INSTALL}: | ${GLIBC_DIR}
	@echo "Folder ${GLIBC_INSTALL} does not exist"
	if [ "${GLIBC_REV}" = "" ]; then \
		cd ${GLIBC_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${GLIBC_DIR}; \
			git fetch; \
        	git checkout -f release/${GLIBC_REV}/master;\
    fi
	mkdir -p ${GLIBC_DIR}/objdir
	cd ${GLIBC_DIR}/objdir; \
		../configure --prefix=${GLIBC_INSTALL}; \
		make clean; \
		make; \
		make install
