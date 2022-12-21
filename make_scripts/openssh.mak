OPENSSH_REPO     := https://github.com/openssh/openssh-portable.git
OPENSSH_REV      ?= V_9_0_P1
OPENSSH_NAME     := openssh
OPENSSH_INSTALL  := ${INSTALL_DIR}/${OPENSSH_NAME}/${OPENSSH_REV}
OPENSSH_DIR      := ${DOWNLOAD_DIR}/${OPENSSH_NAME}-git
OPENSSH_RELEASE  := 0

${OPENSSH_NAME}_clean:
	rm -rf $(OPENSSH_INSTALL)
    
${OPENSSH_NAME}: mkdir_install make | $(OPENSSH_INSTALL)

${OPENSSH_DIR}:
	@echo "Folder ${OPENSSH_INSTALL} does not exist"
	git clone ${OPENSSH_REPO} ${OPENSSH_DIR}

${OPENSSH_INSTALL}: | ${OPENSSH_DIR}
	@echo "Folder ${OPENSSH_INSTALL} does not exist"
	if [ "${OPENSSH_REV}" = "" ]; then \
		cd ${OPENSSH_DIR}; \
			git fetch; \
                     git checkout -f master;\
	else \
		cd ${OPENSSH_DIR}; \
			git fetch; \
                        git checkout -f ${OPENSSH_REV};\
        fi
	mkdir -p ${OPENSSH_DIR}
	cd ${OPENSSH_DIR}; \
		which gcc ; \
		which cc ; \
		autoreconf; \
		./configure --prefix=${OPENSSH_INSTALL} --with-ssl-dir=${OPENSSL_INSTALL} --without-openssl-header-check; \
		make clean; \
		make -j ${PROCESSOR} ; \
		make install
	$(MAKE) ${OPENSSH_NAME}_module
	#$(MAKE) openssh_link

${OPENSSH_NAME}_link:
	ln -fs $(shell ls ${OPENSSH_INSTALL}/bin/*) ${INSTALL_DIR}/local/bin/.
#		./configure --prefix=${OPENSSH_INSTALL} --with-ssl-dir=${OPENSSL_INSTALL}/include --without-openssl-header-check; \

${OPENSSH_NAME}_module: ${OPENSSH_INSTALL}
	@export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export INSTALL_DIR=${INSTALL_DIR};\
	export TOOL=${OPENSSH_NAME};\
	export REV=${OPENSSH_REV};\
	export LD_LIBRARY=1;\
	export RELEASE=${OPENSSH_RELEASE};\
		bash ./module_setup.sh

