LIBICE_REV       ?= 1.0.10
LIBICE_INSTALL   := ${INSTALL_DIR}/libice/${LIBICE_REV}
LIBICE_DIR       := ${DOWNLOAD_DIR}/libICE-${LIBICE_REV}

libice_clean:
	rm -rf ${LIBICE_INSTALL}

libice: mkdir_install gcc make xtrans | ${LIBICE_INSTALL}

${LIBICE_DIR}:
	@echo "Folder ${LIBICE_DIR} does not exist"
	wget --no-check-certificate https://www.x.org/releases/individual/lib/libICE-${LIBICE_REV}.tar.gz
	tar -zxvf libICE-${LIBICE_REV}.tar.gz

${LIBICE_INSTALL}: | ${LIBICE_DIR}
	@echo "Folder ${LIBICE_INSTALL} does not exist"
	cd ${LIBICE_DIR}; \
		export PATH=$(MAKE_INSTALL)/bin:$(GCC_INSTALL)/bin:${PERL_INSTALL}/bin:${PATH}; \
		export ICE_CFLAGS="-I${XTRANS_INSTALL}/include"; \
		export ICE_LIBS="-L${XTRANS_INSTALL}/lib"; \
		./configure --prefix=${LIBICE_INSTALL} --with-perl; \
		make; \
		make install
