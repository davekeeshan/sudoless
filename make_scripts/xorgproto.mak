#!/usr/bin/env make
XORGPROTO_REPO     := https://gitlab.freedesktop.org/xorg/proto/xorgproto.git
XORGPROTO_REV      ?= xorgproto-2022.2
XORGPROTO_INSTALL  := ${INSTALL_DIR}/xorgproto/${XORGPROTO_REV}
XORGPROTO_DIR      := ${DOWNLOAD_DIR}/xorgproto-git

xorgproto_clean:
	rm -rf $(XORGPROTO_INSTALL)
    
xorgproto: mkdir_install gcc make | $(XORGPROTO_INSTALL)

${XORGPROTO_DIR}:
	@echo "Folder ${XORGPROTO_INSTALL} does not exist"
	git clone ${XORGPROTO_REPO} ${XORGPROTO_DIR}


${XORGPROTO_INSTALL}: | ${XORGPROTO_DIR}
	@echo "Folder ${XORGPROTO_INSTALL} does not exist"
	if [ "${XORGPROTO_REV}" = "" ]; then \
		cd ${XORGPROTO_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${XORGPROTO_DIR}; \
			git fetch; \
        	git checkout -f ${XORGPROTO_REV};\
    fi
	cd ${XORGPROTO_DIR}; \
		./autogen.sh; \
	# 	make clean; \
	# 	make;
