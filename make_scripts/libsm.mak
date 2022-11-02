LIBSM_REV       ?= 1.2.3
LIBSM_INSTALL   := ${INSTALL_DIR}/libsm/${LIBSM_REV}
LIBSM_DIR       := ${DOWNLOAD_DIR}/libSM-${LIBSM_REV}

libsm_clean:
	rm -rf ${LIBSM_INSTALL}

libsm: mkdir_install gcc make xtrans libice | ${LIBSM_INSTALL}

${LIBSM_DIR}:
	@echo "Folder ${LIBSM_DIR} does not exist"
	wget --no-check-certificate https://www.x.org/releases/individual/lib/libSM-${LIBSM_REV}.tar.gz
	tar -zxvf libSM-${LIBSM_REV}.tar.gz

${LIBSM_INSTALL}: | ${LIBSM_DIR}
	@echo "Folder ${LIBSM_INSTALL} does not exist"
	cd ${LIBSM_DIR}; \
		export PATH=$(MAKE_INSTALL)/bin:$(GCC_INSTALL)/bin:${PERL_INSTALL}/bin:${PATH}; \
		export SM_CFLAGS="-I${XTRANS_INSTALL}/include -I${LIBICE_INSTALL}/include"; \
		export SM_LIBS="-L${XTRANS_INSTALL}/lib -L${LIBICE_INSTALL}/lib"; \
		./configure --prefix=${LIBSM_INSTALL} --with-perl; \
		make; \
		make install
