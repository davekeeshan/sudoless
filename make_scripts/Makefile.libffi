#!/usr/bin/env make
LIBFFI_REV        ?= 3.4.2
LIBFFI_INSTALL    := ${INSTALL_DIR}/libffi/${LIBFFI_REV}
LIBFFI_DIR        := ${DOWNLOAD_DIR}/libffi-${LIBFFI_REV}

libffi_clean:
	rm -rf ${LIBFFI_INSTALL}

libffi: mkdir_install gcc make | ${LIBFFI_INSTALL}

${LIBFFI_DIR}:
	@echo "Folder ${LIBFFI_DIR} does not exist"
	wget --no-check-certificate -c -P ${DOWNLOAD_DIR} https://github.com/libffi/libffi/releases/download/v${LIBFFI_REV}/libffi-${LIBFFI_REV}.tar.gz
	cd ${DOWNLOAD_DIR}; tar -zxvf libffi-${LIBFFI_REV}.tar.gz

${LIBFFI_INSTALL}: | ${LIBFFI_DIR}
	@echo "Folder ${LIBFFI_INSTALL} does not exist"
	cd ${LIBFFI_DIR}; \
		./configure --prefix=${LIBFFI_INSTALL}; \
		make clean; \
		make; \
		make install
