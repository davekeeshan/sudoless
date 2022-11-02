MOTIF_REV       ?= 2.3.8
MOTIF_INSTALL   := ${INSTALL_DIR}/motif/${MOTIF_REV}
MOTIF_DIR       := ${DOWNLOAD_DIR}/motif-${MOTIF_REV}

motif_clean:
	rm -rf ${MOTIF_INSTALL}

motif: mkdir_install gcc make libxt libsm libice | ${MOTIF_INSTALL}

${MOTIF_DIR}:
	@echo "Folder ${MOTIF_DIR} does not exist"
	wget --no-check-certificate https://sourceforge.net/projects/motif/files/Motif%202.3.8%20Source%20Code/motif-${MOTIF_REV}.tar.gz
	tar -zxvf ${MOTIF_DIR}.tar.gz

${MOTIF_INSTALL}: | ${MOTIF_DIR}
	@echo "Folder ${MOTIF_INSTALL} does not exist"
	cd ${MOTIF_DIR}; \
		export PATH=$(MAKE_INSTALL)/bin:$(GCC_INSTALL)/bin:${PATH}; \
		export CFLAGS="-I${LIBXT_INSTALL}/include -I${LIBSM_INSTALL}/include -I${LIBICE_INSTALL}/include"; \
		export LDFLAGS="-L${LIBXT_INSTALL}/lib -L${LIBSM_INSTALL}/lib -L${LIBICE_INSTALL}/lib"; \
		./configure --prefix=${MOTIF_INSTALL}; \
		make; \
		make install
