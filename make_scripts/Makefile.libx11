LIBX11_REV       ?= 1.8
LIBX11_INSTALL   := ${INSTALL_DIR}/libx11/${LIBX11_REV}
LIBX11_DIR       := ${DOWNLOAD_DIR}/libX11-${LIBX11_REV}

libx11_clean:
	rm -rf ${LIBX11_INSTALL}

libx11: mkdir_install gcc make xtrans xmlto | ${LIBX11_INSTALL}

${LIBX11_DIR}:
	@echo "Folder ${LIBX11_DIR} does not exist"
	wget --no-check-certificate -c -P ${DOWNLOAD_DIR} https://www.x.org/releases/individual/lib/libX11-${LIBX11_REV}.tar.gz
	cd ${DOWNLOAD_DIR}; tar -zxvf ${LIBX11_REV}.tar.gz

${LIBX11_INSTALL}: | ${LIBX11_DIR}
	@echo "Folder ${LIBX11_INSTALL} does not exist"
	cd ${LIBX11_DIR}; \
		export PATH=${XMLTO_INSTALL}/bin:${PATH}; \
		export X11_CFLAGS="-I${XTRANS_INSTALL}/include"; \
		export X11_LIBS="-L${XTRANS_INSTALL}/lib"; \
		./configure --prefix=${LIBX11_INSTALL}; \
		make; \
		make install
