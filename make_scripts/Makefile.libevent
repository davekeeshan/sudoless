LIBEVENT_REPO     := https://github.com/libevent/libevent.git
LIBEVENT_REV      ?= 2.1.12
LIBEVENT_INSTALL  := ${INSTALL_DIR}/libevent/${LIBEVENT_REV}
LIBEVENT_DIR      := ${DOWNLOAD_DIR}/libevent-git

libevent_clean:
	rm -rf ${LIBEVENT_INSTALL}

libevent: mkdir_install gcc openssl | $(LIBEVENT_INSTALL)

${LIBEVENT_DIR}: 
	@echo "Folder ${LIBEVENT_DIR} does not exist"
	git clone ${LIBEVENT_REPO} ${LIBEVENT_DIR}

${LIBEVENT_INSTALL}: | ${LIBEVENT_DIR}
	@echo "Folder $(LIBEVENT_INSTALL) does not exist"
	if [ "${LIBEVENT_REV}" = "" ]; then \
		cd ${LIBEVENT_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${LIBEVENT_DIR}; \
			git fetch; \
        	git checkout -f release-${LIBEVENT_REV}-stable;\
    fi
	cd ${LIBEVENT_DIR}; \
		export CFLAGS="-I${OPENSSL_INSTALL}/include"; \
		export LDFLAGS="-L${OPENSSL_INSTALL}/lib"; \
		./autogen.sh; \
		./configure --prefix=$(LIBEVENT_INSTALL); \
		make clean; \
		make; \
		make install        
