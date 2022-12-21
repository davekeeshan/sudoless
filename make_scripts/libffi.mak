LIBFFI_REV        ?= v3.4.2
LIBFFI_REPO       := http://github.com/libffi/libffi.git
LIBFFI_INSTALL    := ${INSTALL_DIR}/libffi/${LIBFFI_REV}
LIBFFI_DIR        := ${DOWNLOAD_DIR}/libffi-git

libffi_clean:
	rm -rf ${LIBFFI_INSTALL}

libffi: mkdir_install gcc make texinfo autoconf | ${LIBFFI_INSTALL}

${LIBFFI_DIR}:
	@echo "Folder ${LIBFFI_DIR} does not exist"
	git clone ${LIBFFI_REPO} ${LIBFFI_DIR}

${LIBFFI_INSTALL}: | ${LIBFFI_DIR}
	@echo "Folder ${LIBFFI_INSTALL} does not exist"
	if [ "${LIBFFI_REV}" = "" ]; then \
		cd ${LIBFFI_DIR}; \
			git pull; \
			git checkout -f master;\
	else \
		cd ${LIBFFI_DIR}; \
			git pull; \
			git checkout -f ${LIBFFI_REV};\
	fi
	cd ${LIBFFI_DIR}; \
		export PATH=${AUTOCONF_INSTALL}/bin:${TEXINFO_INSTALL}/bin:${PATH}; \
		./autogen.sh; \
		./configure --prefix=${LIBFFI_INSTALL}; \
		make clean; \
		make -j ${PROCESSOR}; \
		make install


