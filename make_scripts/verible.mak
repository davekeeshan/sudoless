VERIBLE_REPO      := https://github.com/chipsalliance/verible.git
#VERIBLE_REV       ?= $(shell git ls-remote ${VERIBLE_REPO} | head -1 | awk '{print $$1}')
VERIBLE_REV       ?= v0.0-2433-ga2c384c2
VERIBLE_NAME      := verible
VERIBLE_INSTALL   := ${INSTALL_DIR}/${VERIBLE_NAME}/${VERIBLE_REV}
VERIBLE_DIR       := ${DOWNLOAD_DIR}/verible-git
VERIBLE_RELEASE   := 0
VERIBLE_GRELEASE  := v0.0-2479-g92928558

verible_clean:
	rm -rf ${VERIBLE_INSTALL}

verible: mkdir_install bazel_release gcc bison flex python | ${VERIBLE_INSTALL}

${VERIBLE_DIR}:
	@echo "Folder ${VERIBLE_DIR} does not exist"
	git clone ${VERIBLE_REPO} ${VERIBLE_DIR}

${VERIBLE_INSTALL}: | ${VERIBLE_DIR}
	@echo "Folder ${VERIBLE_INSTALL} does not exist"
	if [ "${VERIBLE_REV}" = "" ]; then \
		cd ${VERIBLE_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${VERIBLE_DIR}; \
			git fetch; \
        	git checkout -f ${VERIBLE_REV};\
    fi
	cd ${VERIBLE_DIR}; \
		export PATH=${FLEX_INSTALL}/bin:${BAZEL_RELEASE}/bin:${PATH}; \
		bazel sync;\
		bazel build -c opt --//bazel:use_local_flex_bison //...; \
		bazel run -c opt :install -- ${VERIBLE_INSTALL}/bin
	${MAKE} verible_module

VERIBLE_GRELEASE:
	mkdir -p ${INSTALL_DIR}/verible
	wget --no-check-certificate -c -P ${DOWNLOAD_DIR} https://github.com/chipsalliance/verible/releases/download/${VERIBLE_GRELEASE}/verible-${VERIBLE_GRELEASE}-CentOS-7.9.2009-Core-x86_64.tar.gz
	cd ${DOWNLOAD_DIR} ; tar -zxvf verible-${VERIBLE_GRELEASE}-CentOS-7.9.2009-Core-x86_64.tar.gz
	cd ${DOWNLOAD_DIR} ; cp -r verible-${VERIBLE_GRELEASE} ${INSTALL_DIR}/verible/${VERIBLE_GRELEASE}


verible_module: ${VERIBLE_INSTALL}
	@export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export TOOL=${VERIBLE_NAME};\
	export REV=${VERIBLE_REV};\
	export RELEASE=${VERIBLE_RELEASE};\
		./module_setup.sh
