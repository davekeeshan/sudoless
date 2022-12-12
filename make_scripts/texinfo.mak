TEXINFO_REV       ?= 6.0
TEXINFO_INSTALL   := ${INSTALL_DIR}/texinfo/${TEXINFO_REV}

texinfo: mkdir_install gcc make perl | ${TEXINFO_INSTALL}

${TEXINFO_INSTALL}:
	@echo "Folder ${TEXINFO_INSTALL} does not exist"
	wget --no-check-certificate -c -P ${DOWNLOAD_DIR} https://ftp.gnu.org/gnu/texinfo/texinfo-${TEXINFO_REV}.tar.gz
	cd ${DOWNLOAD_DIR}; tar -zxvf texinfo-${TEXINFO_REV}.tar.gz
	cd ${DOWNLOAD_DIR}/texinfo-${TEXINFO_REV}; \
		./configure --prefix=${TEXINFO_INSTALL}; \
		make clean; \
		make; \
		make install
