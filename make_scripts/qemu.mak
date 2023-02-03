QEMU_REPO     := https://gitlab.com/qemu-project/qemu.git
QEMU_REV      ?= v7.2.0
QEMU_NAME     := qemu
QEMU_INSTALL  := ${INSTALL_DIR}/${QEMU_NAME}/${QEMU_REV}
QEMU_DIR      := ${DOWNLOAD_DIR}/qemu-git
QEMU_RELEASE  := 0

${QEMU_NAME}_clean:
	rm -rf ${QEMU_INSTALL}
    
${QEMU_NAME}: mkdir_install gcc make | ${QEMU_INSTALL}

${QEMU_DIR}:
	@echo "Folder ${QEMU_INSTALL} does not exist"
	git clone ${QEMU_REPO} ${QEMU_DIR}


${QEMU_INSTALL}: | ${QEMU_DIR}
	${MAKE} pyactivate
	@echo "Folder ${QEMU_INSTALL} does not exist"
	if [ "${QEMU_REV}" = "" ]; then \
		cd ${QEMU_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${QEMU_DIR}; \
			git fetch; \
        	git checkout -f ${QEMU_REV};\
    fi
	#mkdir -p ${QEMU_DIR}
	cd ${QEMU_DIR}; \
		export PATH=${VENV_PATH}/bin:${PATH}; \
		pip install ninja; \
		git submodule init ; \
		git submodule update --recursive ; \
		./configure --prefix=${QEMU_INSTALL} ; \
		make clean; \
		make -j ${PROCESSOR}; \
		make install
	${MAKE} pydeactivate
	${MAKE} ${QEMU_NAME}_module

${QEMU_NAME}_module: ${QEMU_INSTALL}
	@export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export INSTALL_DIR=${INSTALL_DIR};\
	export TOOL=${QEMU_NAME};\
	export REV=${QEMU_REV};\
	export RELEASE=${QEMU_RELEASE};\
		./module_setup.sh
