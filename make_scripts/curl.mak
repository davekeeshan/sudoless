#CURL_REPO       := https://github.com/curl/curl.git
CURL_REPO       := git@github.com:curl/curl.git
CURL_REV        ?= curl-7_84_0
CURL_NAME       := curl
CURL_INSTALL    := ${INSTALL_DIR}/${CURL_NAME}/${CURL_REV}
CURL_DIR        := ${DOWNLOAD_DIR}/curl-git
CURL_RELEASE    := 0
SYSTEM_CURL     ?= 1

ifeq ($(SYSTEM_CURL), 0)
	LD_LIBRARY_PATH:=${OPENSSL_INSTALL}/lib:${CURL_INSTALL}/lib:${LD_LIBRARY_PATH}
	PATH:=${CURL_INSTALL}/bin:${PATH}
endif

curl_clean:
	rm -rf ${CURL_INSTALL}

curl: mkdir_install gcc make openssl autoconf | ${CURL_INSTALL}

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
		export PATH=${AUTOCONF_INSTALL}/bin:${PATH} ;\
		autoreconf -fi ;\
		./configure --prefix=${CURL_INSTALL} --with-openssl=${OPENSSL_INSTALL}; \
		make clean; \
		make; \
		make install
	#${MAKE} curl_link
	${MAKE} curl_module
else
	@echo "Using System CURL"
endif

curl_link:
	ln -fs $(shell ls ${CURL_INSTALL}/lib/libcurl*.so*) ${INSTALL_DIR}/local/lib/.
	ln -fs $(shell ls ${CURL_INSTALL}/bin/*) ${INSTALL_DIR}/local/bin/.

curl_module: ${CURL_INSTALL}
	@export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export INSTALL_DIR=${INSTALL_DIR};\
	export TOOL=${CURL_NAME};\
	export REV=${CURL_REV};\
	export LD_LIBRARY=1;\
	export EXTRA_OPTS="    prepend-path     LD_LIBRARY_PATH ${OPENSSL_INSTALL}/lib64";\
	export RELEASE=${CURL_RELEASE};\
		bash ./module_setup.sh

