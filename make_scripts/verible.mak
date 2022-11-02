VERIBLE_REPO      := https://github.com/chipsalliance/verible.git
# VERIBLE_REV       ?= $(shell git ls-remote ${VERIBLE_REPO} | head -1 | awk '{print $$1}')
VERIBLE_REV       ?= v0.0-2433-ga2c384c2
VERIBLE_INSTALL   := ${INSTALL_DIR}/verible/${VERIBLE_REV}
VERIBLE_DIR       := ${DOWNLOAD_DIR}/verible-git
VERIBLE_RELEASE   := v0.0-2433-ga2c384c2

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

verible_release:
	mkdir -p ${INSTALL_DIR}/verible
	rm -rf verible-${VERIBLE_RELEASE}*
	wget --no-check-certificate https://github.com/chipsalliance/verible/releases/download/${VERIBLE_RELEASE}/verible-${VERIBLE_RELEASE}-CentOS-7.9.2009-Core-x86_64.tar.gz
	tar -zxvf verible-${VERIBLE_RELEASE}-CentOS-7.9.2009-Core-x86_64.tar.gz
	cp -r verible-${VERIBLE_RELEASE} ${INSTALL_DIR}/verible/${VERIBLE_RELEASE}
