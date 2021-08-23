LIBXPM_REV       ?= 3.5.13
LIBXPM_INSTALL   := ${INSTALL_DIR}/libxpm/${LIBXPM_REV}
LIBXPM_DIR       := ${DOWNLOAD_DIR}/libXpm-${LIBXPM_REV}

libxpm_clean:
	rm -rf ${LIBXPM_INSTALL}

libxpm: mkdir_install gcc make | ${LIBXPM_INSTALL}

${LIBXPM_DIR}:
	@echo "Folder ${LIBXPM_DIR} does not exist"
	wget --no-check-certificate https://www.x.org/releases/individual/lib/libXpm-${LIBXPM_REV}.tar.gz
	tar -zxvf ${LIBXPM_DIR}.tar.gz

${LIBXPM_INSTALL}: | ${LIBXPM_DIR}
	@echo "Folder ${LIBXPM_INSTALL} does not exist"
	cd ${LIBXPM_DIR}; \
		export PATH=$(MAKE_INSTALL)/bin:$(GCC_INSTALL)/bin:${PATH}; \
		./configure --prefix=${LIBXPM_INSTALL}; \
		make; \
		make install
