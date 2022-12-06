#CURL_REPO       := https://github.com/curl/curl.git
CURL_REPO       := git@github.com:curl/curl.git
CURL_REV        ?= curl-7_84_0
CURL_INSTALL    := ${INSTALL_DIR}/curl/${CURL_REV}
CURL_DIR        := ${DOWNLOAD_DIR}/curl-git
SYSTEM_CURL     ?= 1

ifeq ($(SYSTEM_CURL), 0)
	PATH := $(CURL_INSTALL)/bin:${PATH}
endif

curl_clean:
	rm -rf ${CURL_INSTALL}

curl: mkdir_install gcc make openssl | ${CURL_INSTALL}

${CURL_DIR}: 
ifeq (${SYSTEM_CURL}, 0)
	@echo "Folder ${CURL_DIR} does not exist"
	git clone ${CURL_REPO} ${CURL_DIR}
endif

${CURL_INSTALL}: | ${CURL_DIR}
ifeq (${SYSTEM_CURL}, 0)
	@echo "Folder ${CURL_INSTALL} does not exist"
	if [ "${CURL_REV}" = "" ]; then \
		cd ${CURL_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${CURL_DIR}; \
			git fetch; \
        	git checkout -f ${CURL_REV};\
    fi
	cd ${CURL_DIR}; \
		autoreconf -fi ;\
		./configure --prefix=${CURL_INSTALL} --with-openssl=${OPENSSL_INSTALL}; \
		make clean; \
		make; \
		make install
	$(MAKE) curl_link
else
	@echo "Using System CURL"
endif

curl_link:
	ln -fs $(shell ls ${CURL_INSTALL}/lib/libcurl*.so*) ${INSTALL_DIR}/local/lib/.
	ln -fs $(shell ls ${CURL_INSTALL}/bin/*) ${INSTALL_DIR}/local/bin/.

