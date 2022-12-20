RAKUDO_REPO          := https://github.com/rakudo/rakudo.git
#RAKUDO_REPO          := git@github.com:rakudo/rakudo.git
RAKUDO_REV           ?= 2022.12
RAKUDO_NAME          := rakudo
RAKUDO_INSTALL       := ${INSTALL_DIR}/${RAKUDO_NAME}/${RAKUDO_REV}
RAKUDO_DIR           := ${DOWNLOAD_DIR}/${RAKUDO_NAME}-git
RAKUDO_RELEASE       := 0
SYSTEM_RAKUDO        := 0

ifeq ($(SYSTEM_RAKUDO), 0)
	PATH := ${RAKUDO_INSTALL}/bin:${PATH}
endif

${RAKUDO_NAME}_clean:
	rm -rf ${RAKUDO_INSTALL}

${RAKUDO_NAME}: mkdir_install gcc make perl | ${RAKUDO_INSTALL}

${RAKUDO_DIR}: 
ifeq (${SYSTEM_RAKUDO}, 0)
	@echo "Folder ${RAKUDO_DIR} does not exist"
	git clone ${RAKUDO_REPO} ${RAKUDO_DIR}
endif

${RAKUDO_INSTALL}: | ${RAKUDO_DIR}
ifeq (${SYSTEM_RAKUDO}, 0)
	@echo "Folder ${RAKUDO_INSTALL} does not exist"
	if [ "${RAKUDO_REV}" = "" ]; then \
		cd ${RAKUDO_DIR}; \
			git fetch; \
			git checkout -f master;\
	else \
		cd ${RAKUDO_DIR}; \
			git fetch; \
			git checkout -f ${RAKUDO_REV};\
    fi
	cd ${RAKUDO_DIR} ; \
		perl Configure.pl -prefix=${RAKUDO_INSTALL} --gen-moar --gen-nqp --backends=moar; \
		make -j ${PROCESSOR}; \
		make install
	#${MAKE} rakudo_module
else
	@echo "Using System rakudo"
endif

rakudo_module: ${RAKUDO_INSTALL}
	@export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export INSTALL_DIR=${INSTALL_DIR};\
	export TOOL=${RAKUDO_NAME};\
	export REV=${RAKUDO_REV};\
	export RELEASE=${RAKUDO_RELEASE};\
		bash ./module_setup.sh
