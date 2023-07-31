# sudo apt-get install libusb-1.0-0-dev libgpiod-dev
OPENOCD_REPO      := https://git.code.sf.net/p/openocd/code
#OPENOCD_REV       ?= $(shell git ls-remote ${OPENOCD_REPO} | head -1 | awk '{print $$1}')
OPENOCD_REV       ?= v0.12.0
OPENOCD_NAME      := openocd
OPENOCD_INSTALL   := ${INSTALL_DIR}/${OPENOCD_NAME}/${OPENOCD_REV}
OPENOCD_DIR       := ${DOWNLOAD_DIR}/openocd-git
OPENOCD_RELEASE   := 0
OPENOCD_GRELEASE  := v0.0-2479-g92928558

${OPENOCD_NAME}_clean:
	rm -rf ${OPENOCD_INSTALL}

${OPENOCD_NAME}: mkdir_install gcc | ${OPENOCD_INSTALL}

${OPENOCD_DIR}:
	@echo "Folder ${OPENOCD_DIR} does not exist"
	echo ${LD_LIBRARY_PATH}
	git clone ${OPENOCD_REPO} ${OPENOCD_DIR}

${OPENOCD_INSTALL}: | ${OPENOCD_DIR}
	@echo "Folder ${OPENOCD_INSTALL} does not exist"
	if [ "${OPENOCD_REV}" = "" ]; then \
		cd ${OPENOCD_DIR}; \
			git fetch; \
			git checkout -f master;\
	else \
		cd ${OPENOCD_DIR}; \
			git fetch; \
			git checkout -f ${OPENOCD_REV};\
	fi
	cd ${OPENOCD_DIR}; \
		export PATH=${PATH}; \
		./bootstrap ; \
		./configure  --prefix=${OPENOCD_INSTALL}; \
		make ; \
		make install	
	${MAKE} ${OPENOCD_NAME}_module

${OPENOCD_NAME}_module: ${OPENOCD_INSTALL}
	export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export INSTALL_DIR=${INSTALL_DIR};\
	export TOOL=${OPENOCD_NAME};\
	export REV=${OPENOCD_REV};\
	export RELEASE=${OPENOCD_RELEASE};\
		./module_setup.sh
