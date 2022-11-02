BZIP2_REPO         := https://github.com/libarchive/bzip2.git
BZIP2_REV          ?= bzip2-1.0.8
BZIP2_INSTALL      := ${INSTALL_DIR}/bzip2/${BZIP2_REV}
BZIP2_DIR          := ${DOWNLOAD_DIR}/bzip2-git

# override TAG_REV   = ${BZIP2_REV}
# override TAG_DIR   = ${BZIP2_DIR}
# override TAG_REPO  = ${BZIP2_REPO}

bzip2_clean:
	rm -rf ${BZIP2_INSTALL}

bzip2: mkdir_install gcc | ${BZIP2_INSTALL}

${BZIP2_DIR}: 
	#${MAKE} git_clone
	@echo "Folder ${BZIP2_DIR} does not exist"
	git clone ${BZIP2_REPO} ${BZIP2_DIR}

${BZIP2_INSTALL}: | ${BZIP2_DIR}
	@echo "Folder ${BZIP2_INSTALL} does not exist"
	#${MAKE} git_fetch
	if [ "${BZIP2_REV}" = "" ]; then \
		cd ${BZIP2_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${BZIP2_DIR}; \
			git fetch; \
        	git checkout -f ${BZIP2_REV};\
    fi
	cd ${BZIP2_DIR}; \
		export PATH=${GCC_INSTALL}/bin:${PATH}; \
		export CC=${GCC_INSTALL}/bin/gcc -fPIC; \
        make distclean; \
		make -f Makefile-libbz2_so; \
  		make install PREFIX=${BZIP2_INSTALL}; \
		cp libbz2.so* ${BZIP2_INSTALL}/lib/.; \
		cp bzip2-shared ${BZIP2_INSTALL}/lib/.
#         make; \
