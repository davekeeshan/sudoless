LIBTOOLS_REPO     := https://github.com/autotools-mirror/libtool.git
LIBTOOLS_REV      ?= v2.4.7
LIBTOOLS_INSTALL  := ${INSTALL_DIR}/libtools/${LIBTOOLS_REV}
LIBTOOLS_DIR      := ${DOWNLOAD_DIR}/libtools-git

libtools_clean:
	rm -rf ${LIBTOOLS_INSTALL}

libtools: mkdir_install gcc autoconf help2man texinfo | ${LIBTOOLS_INSTALL}

${LIBTOOLS_DIR}: 
	@echo "Folder ${LIBTOOLS_DIR} does not exist"
	git clone ${LIBTOOLS_REPO} ${LIBTOOLS_DIR}

${LIBTOOLS_INSTALL}: | ${LIBTOOLS_DIR}
	@echo "Folder $(LIBTOOLS_INSTALL) does not exist"
	if [ "${LIBTOOLS_REV}" = "" ]; then \
		cd ${LIBTOOLS_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${LIBTOOLS_DIR}; \
			git fetch; \
        	git checkout -f ${LIBTOOLS_REV};\
    fi
	rm -rf ${LIBTOOLS_DIR}/build
	mkdir -p ${LIBTOOLS_DIR}/build
	cd ${LIBTOOLS_DIR}; \
		export PATH=${AUTOCONF_INSTALL}/bin:${TEXINFO_INSTALL}/bin:${HELP2MAN_INSTALL}/bin:${PATH}; \
		export MAKEINFO=${TEXINFO_INSTALL}/bin/makeinfo; \
		which makeinfo ; \
		./bootstrap; \
		./configure --prefix=$(LIBTOOLS_INSTALL); \
		make clean; \
		make -j ${PROCESSOR}; \
		make install        
     
