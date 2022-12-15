#OPENSSL_REPO       := https://github.com/openssl/openssl.git
OPENSSL_REPO       := git@github.com:openssl/openssl.git
OPENSSL_REV        ?= openssl-3.0.7
OPENSSL_NAME       := openssl
OPENSSL_INSTALL    := ${INSTALL_DIR}/${OPENSSL_NAME}/${OPENSSL_REV}
OPENSSL_DIR        := ${DOWNLOAD_DIR}/openssl-git
OPENSSL_RELEASE    := 0

${OPENSSL_NAME}_clean:
	rm -rf ${OPENSSL_INSTALL}

${OPENSSL_NAME}: mkdir_install gcc make perl | ${OPENSSL_INSTALL}

${OPENSSL_DIR}: 
	@echo "Folder ${OPENSSL_DIR} does not exist"
	git clone ${OPENSSL_REPO} ${OPENSSL_DIR}

${OPENSSL_INSTALL}: | ${OPENSSL_DIR}
	@echo "Folder ${OPENSSL_INSTALL} does not exist"
	if [ "${OPENSSL_REV}" = "" ]; then \
		cd ${OPENSSL_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${OPENSSL_DIR}; \
			git fetch; \
        	git checkout -f ${OPENSSL_REV};\
    fi
	mkdir -p ${OPENSSL_DIR}/build
	cd ${OPENSSL_DIR} ; \
		./config --prefix=${OPENSSL_INSTALL}; \
		make clean; \
		make; \
		make install; \
        ln -s ${OPENSSL_INSTALL}/lib64 ${OPENSSL_INSTALL}/lib 
	${MAKE} openssl_module
	#${MAKE} openssl_link

${OPENSSL_NAME}_link:
	ln -fs $(shell ls ${OPENSSL_INSTALL}/lib/lib*.so*) ${INSTALL_DIR}/local/lib/.
	
${OPENSSL_NAME}_module: ${OPENSSL_INSTALL}
	@export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export INSTALL_DIR=${INSTALL_DIR};\
	export TOOL=${OPENSSL_NAME};\
	export REV=${OPENSSL_REV};\
	export LD_LIBRARY=1;\
	export ADD_PATH=0;\
	export RELEASE=${OPENSSL_RELEASE};\
		bash ./module_setup.sh

