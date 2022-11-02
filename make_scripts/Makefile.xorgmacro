#!/usr/bin/env make
XORGMACRO_REPO     := https://github.com/freedesktop/xorg-macros.git
XORGMACRO_REV      ?= util-macros-1.19.1
XORGMACRO_INSTALL  := ${INSTALL_DIR}/xorgmacro/${XORGMACRO_REV}
XORGMACRO_DIR      := ${DOWNLOAD_DIR}/xorgmacro-git

xorgmacro_clean:
	rm -rf $(XORGMACRO_INSTALL)
    
xorgmacro: mkdir_install gcc make | $(XORGMACRO_INSTALL)

${XORGMACRO_DIR}:
	@echo "Folder ${XORGMACRO_INSTALL} does not exist"
	git clone ${XORGMACRO_REPO} ${XORGMACRO_DIR}


${XORGMACRO_INSTALL}: | ${XORGMACRO_DIR}
	@echo "Folder ${XORGMACRO_INSTALL} does not exist"
	if [ "${XORGMACRO_REV}" = "" ]; then \
		cd ${XORGMACRO_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${XORGMACRO_DIR}; \
			git fetch; \
        	git checkout -f ${XORGMACRO_REV};\
    fi
	cd ${XORGMACRO_DIR}; \
		./autogen.sh; \
		./configure --prefix=${XORGMACRO_INSTALL}; \
	 	make clean; \
		make; \
		make install;

