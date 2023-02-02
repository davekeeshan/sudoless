RISCVTESTS_NAME     := riscv-tests
RISCVTESTS_REPO     := https://github.com/riscv-software-src/riscv-tests.git
RISCVTESTS_REV      ?= 55bbcc8
RISCVTESTS_INSTALL  := ${INSTALL_DIR}/${RISCVTESTS_NAME}/${RISCVTESTS_REV}
RISCVTESTS_DIR      := ${DOWNLOAD_DIR}/${RISCVTESTS_NAME}-git


${RISCVTESTS_NAME}_clean:
	rm -rf ${RISCVTESTS_INSTALL}
    
${RISCVTESTS_NAME}: mkdir_install make autoconf ${RISCVTOOLCHAIN_NAME} | ${RISCVTESTS_INSTALL}

${RISCVTESTS_DIR}:
	@echo "Folder ${RISCVTESTS_INSTALL} does not exist"
	git clone ${RISCVTESTS_REPO} ${RISCVTESTS_DIR}

${RISCVTESTS_INSTALL}: | ${RISCVTESTS_DIR}
	@echo "Folder ${RISCVTESTS_INSTALL} does not exist"
	if [ "${RISCVTESTS_REV}" = "" ]; then \
		cd ${RISCVTESTS_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${RISCVTESTS_DIR}; \
			git fetch; \
        	git checkout -f ${RISCVTESTS_REV};\
    fi
	# rm -rf ${RISCVTESTS_DIR}/build
	# mkdir -p ${RISCVTESTS_DIR}/build
	cd ${RISCVTESTS_DIR}; \
		export PATH=${RISCVTOOLCHAIN_INSTALL}/bin:${AUTOCONF_INSTALL}/bin:${PATH}; \
		git submodule update --init --recursive;\
		autoconf;\
		./configure --prefix=${RISCVTOOLCHAIN_INSTALL}/target; \
		make clean; \
		make -j ${PROCESSOR}; \
		make install

