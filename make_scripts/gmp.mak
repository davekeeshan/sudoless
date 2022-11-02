GMP_REV        ?= 6.2.1
GMP_INSTALL    := ${INSTALL_DIR}/gmp/${GMP_REV}
GMP_DIR        := ${DOWNLOAD_DIR}/gmp-${GMP_REV}

gmp_clean:
	rm -rf ${GMP_INSTALL}

gmp: mkdir_install gcc make | ${GMP_INSTALL}

${GMP_DIR}:
	@echo "Folder ${GMP_DIR} does not exist"
	rm -rf gmp*
	wget --no-check-certificate https://gmplib.org/download/gmp/gmp-${GMP_REV}.tar.xz
	tar -xvf gmp-${GMP_REV}.tar*

${GMP_INSTALL}: | ${GMP_DIR}
	@echo "Folder ${GMP_INSTALL} does not exist"
	cd ${GMP_DIR}; \
		export PATH=${GCC_INSTALL}/bin:${MAKE_INSTALL}/bin:${PATH}; \
		./configure --prefix=${GMP_INSTALL}; \
		make; \
		make install
# 	rm -rf gmp*
