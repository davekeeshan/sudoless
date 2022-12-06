XY_REPO         := https://git.tukaani.org/xz.git
XY_REV          ?= v5.2.8
XY_INSTALL      := ${INSTALL_DIR}/xy/${XY_REV}
XY_DIR          := ${DOWNLOAD_DIR}/xy-git

xy_clean:
	rm -rf ${XY_INSTALL}

xy: mkdir_install gcc make autoconf automake gettext libtools | ${XY_INSTALL}

${XY_DIR}: 
	@echo "Folder ${XY_DIR} does not exist"
	git clone ${XY_REPO} ${XY_DIR}

${XY_INSTALL}: | ${XY_DIR}
	@echo "Folder ${XY_INSTALL} does not exist"
	if [ "${XY_REV}" = "" ]; then \
		cd ${XY_DIR}; \
			git pull; \
			git checkout master;\
	else \
		cd ${XY_DIR}; \
			git pull; \
			git checkout ${XY_REV};\
	fi
	cd ${XY_DIR}; \
		export PATH=${AUTOCONF_INSTALL}/bin:${AUTOMAKE_INSTALL}/bin:${LIBTOOLS_INSTALL}/bin:${GETTEXT_INSTALL}/bin:${PATH}; \
		./autogen.sh; \
		./configure --prefix=${XY_INSTALL}; \
		make clean; \
		make -j ${PROCESSOR}; \
		make install        
