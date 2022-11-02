#!/usr/bin/env make
BAZEL_REPO     := https://github.com/bazelbuild/bazel
BAZEL_REV      ?= 5.3.1
BAZEL_INSTALL  := ${INSTALL_DIR}/bazel/${BAZEL_REV}
BAZEL_DIR      := ${DOWNLOAD_DIR}/bazel-git
BAZEL_RELEASE  := ${BAZEL_INSTALL}-bootstrap

bazel_clean:
	rm -rf ${BAZEL_INSTALL} ${BAZEL_INSTALL}-bootstrap
    
bazel: mkdir_install gcc make bazel_release pyactivate | ${BAZEL_INSTALL}

${BAZEL_DIR}:
	@echo "Folder ${BAZEL_INSTALL} does not exist"
	git clone ${BAZEL_REPO} ${BAZEL_DIR}


${BAZEL_INSTALL}: | ${BAZEL_DIR}
	@echo "Folder ${BAZEL_INSTALL} does not exist"
	if [ "${BAZEL_REV}" = "" ]; then \
		cd ${BAZEL_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${BAZEL_DIR}; \
			git fetch; \
        	git checkout -f ${BAZEL_REV};\
    fi
	mkdir -p ${BAZEL_DIR}
	cd ${BAZEL_DIR}; \
		export PATH=${VENV_PATH}/bin:${BASH_INSTALL}/bin:$(BAZEL_INSTALL)-bootstrap/bin:${PATH}; \
		export LD_LIBRARY_PATH=${PYTHON_INSTALL}/lib:${LD_LIBRARY_PATH}; \
		echo ${LD_LIBRARY_PATH}; \
		bazel sync;\
		bazel build //src:bazel-dev; \
# 		bazel run -c opt :install -- ${BAZEL_INSTALL}

# 		./autogen.sh ; \
# 		./configure --prefix=${BAZEL_INSTALL} ; \
# 		make clean; \
# 		make; \
# 		make install

bazel_release: | ${BAZEL_RELEASE}

${BAZEL_RELEASE}:
	@echo "Folder ${BAZEL_RELEASE} does not exist"
	rm -rf bazel*-linux*
	wget --no-check-certificate https://github.com/bazelbuild/bazel/releases/download/${BAZEL_REV}/bazel-${BAZEL_REV}-linux-x86_64
	mkdir -p ${BAZEL_RELEASE}/bin
	mv bazel-${BAZEL_REV}-linux-x86_64 ${BAZEL_RELEASE}/bin/bazel
	chmod +x ${BAZEL_RELEASE}/bin/bazel
	rm -rf bazel*-linux*

