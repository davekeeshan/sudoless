LIBXT_REV       ?= 1.2.1
LIBXT_INSTALL   := ${INSTALL_DIR}/libxt/${LIBXT_REV}
LIBXT_DIR       := ${DOWNLOAD_DIR}/libXt-${LIBXT_REV}

libxt_clean:
	rm -rf ${LIBXT_INSTALL}

libxt: mkdir_install gcc make libsm libice | ${LIBXT_INSTALL}

${LIBXT_DIR}:
	@echo "Folder ${LIBXT_DIR} does not exist"
	wget --no-check-certificate https://www.x.org/releases/individual/lib/libXt-${LIBXT_REV}.tar.gz
	tar -zxvf libXt-${LIBXT_REV}.tar.gz

${LIBXT_INSTALL}: | ${LIBXT_DIR}
	@echo "Folder ${LIBXT_INSTALL} does not exist"
	cd ${LIBXT_DIR}; \
		export PATH=$(MAKE_INSTALL)/bin:$(GCC_INSTALL)/bin:${PATH}; \
		export XT_CFLAGS="-I${LIBSM_INSTALL}/include -I${LIBICE_INSTALL}/include"; \
		export XT_LIBS="-L${LIBSM_INSTALL}/lib -L${LIBICE_INSTALL}/lib"; \
		./configure --prefix=${LIBXT_INSTALL}; \
		make; \
		make install
