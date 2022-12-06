UTILLINUX_REV        ?= 2.38.1
UTILLINUX_REPO       := https://github.com/util-linux/util-linux.git
UTILLINUX_INSTALL    := ${INSTALL_DIR}/utillinux/${UTILLINUX_REV}
UTILLINUX_DIR        := ${DOWNLOAD_DIR}/utillinux-git
UTILLINUX_DIR_wget   := ${DOWNLOAD_DIR}/util-linux-${UTILLINUX_REV}

utillinux_clean:
	rm -rf ${UTILLINUX_INSTALL}

utillinux: mkdir_install gcc make autoconf automake libtools gettext bison | ${UTILLINUX_INSTALL}
utillinux_wget: mkdir_install gcc make autoconf automake libtools gettext bison | ${UTILLINUX_INSTALL}_wget

${UTILLINUX_DIR}:
	@echo "Folder ${UTILLINUX_DIR} does not exist"
	git clone ${UTILLINUX_REPO} ${UTILLINUX_DIR}

${UTILLINUX_INSTALL}: | ${UTILLINUX_DIR}
	@echo "Folder ${UTILLINUX_INSTALL} does not exist"
	if [ "${UTILLINUX_REV}" = "" ]; then \
		cd ${UTILLINUX_DIR}; \
			git pull; \
			git checkout -f master;\
	else \
		cd ${UTILLINUX_DIR}; \
			git pull; \
			git checkout -f v${UTILLINUX_REV};\
	fi
	cd ${UTILLINUX_DIR}; \
		export PATH=${AUTOCONF_INSTALL}/bin:${AUTOMAKE_INSTALL}/bin:${LIBTOOLS_INSTALL}/bin:${GETTEXT_INSTALL}/bin:${BISON_INSTALL}/bin:${PATH}; \
		export AL_OPTS=-I${GETTEXT_INSTALL}/share/aclocal ; \
		./autogen.sh; \
		./configure --prefix=${UTILLINUX_INSTALL}; \
		make clean; \
		make -j ${PROCESSOR}; \
		make install

${UTILLINUX_DIR}_wget:
	@echo "Folder ${UTILLINUX_DIR_wget} does not exist"
	wget --no-check-certificate -c -P ${DOWNLOAD_DIR} https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.38/util-linux-${UTILLINUX_REV}.tar.gz
	#cd ${DOWNLOAD_DIR}; tar -xf util-linux-${UTILLINUX_REV}.tar*

${UTILLINUX_INSTALL}_wget: | ${UTILLINUX_DIR}_wget
	cd ${DOWNLOAD_DIR}/util-linux-${UTILLINUX_REV}; \
		export PATH=${AUTOCONF_INSTALL}/bin:${AUTOMAKE_INSTALL}/bin:${LIBTOOLS_INSTALL}/bin:${GETTEXT_INSTALL}/bin:${BISON_INSTALL}/bin:${PATH}; \
		./configure --prefix=${UTILLINUX_INSTALL} ; \
		make clean ; \
		make -j ${PROCESSOR} ; \
		make install

