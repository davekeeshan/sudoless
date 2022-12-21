RISCVTOOLCHAIN_ARCH     := dual
RISCVTOOLCHAIN_NAME     := riscv-toolchain
RISCVTOOLCHAIN_REPO     := https://github.com/riscv/riscv-gnu-toolchain
RISCVTOOLCHAIN_REV      ?= 2022.11.23
RISCVTOOLCHAIN_INSTALL  := ${INSTALL_DIR}/${RISCVTOOLCHAIN_NAME}/${RISCVTOOLCHAIN_REV}-${RISCVTOOLCHAIN_ARCH}
RISCVTOOLCHAIN_DIR      := ${DOWNLOAD_DIR}/${RISCVTOOLCHAIN_NAME}-git
RISCVTOOLCHAIN_MAKEOPTS := linux

ifeq ($(RISCVTOOLCHAIN_ARCH), 64)
	RISCVTOOLCHAIN_EXTRA := 
else ifeq ($(RISCVTOOLCHAIN_ARCH), 32)
    RISCVTOOLCHAIN_EXTRA := --with-arch=rv32gc --with-abi=ilp32d
else
    RISCVTOOLCHAIN_EXTRA := --enable-multilib
endif

${RISCVTOOLCHAIN_NAME}_clean:
	rm -rf ${RISCVTOOLCHAIN_INSTALL}
    
${RISCVTOOLCHAIN_NAME}: mkdir_install make texinfo | ${RISCVTOOLCHAIN_INSTALL}

${RISCVTOOLCHAIN_DIR}:
	@echo "Folder ${RISCVTOOLCHAIN_INSTALL} does not exist"
	git clone ${RISCVTOOLCHAIN_REPO} ${RISCVTOOLCHAIN_DIR}

${RISCVTOOLCHAIN_INSTALL}: | ${RISCVTOOLCHAIN_DIR}
	@echo "Folder ${RISCVTOOLCHAIN_INSTALL} does not exist"
	if [ "${RISCVTOOLCHAIN_REV}" = "" ]; then \
		cd ${RISCVTOOLCHAIN_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${RISCVTOOLCHAIN_DIR}; \
			git fetch; \
        	git checkout -f ${RISCVTOOLCHAIN_REV};\
    fi
	rm -rf ${RISCVTOOLCHAIN_DIR}/build
	mkdir -p ${RISCVTOOLCHAIN_DIR}/build
	cd ${RISCVTOOLCHAIN_DIR}/build; \
		export PATH=${RISCVTOOLCHAIN_INSTALL}/bin:${TEXINFO_INSTALL}/bin:${PATH}; \
		../configure --prefix=${RISCVTOOLCHAIN_INSTALL} ${RISCVTOOLCHAIN_EXTRA}; \
		make clean; \
		make -j ${PROCESSOR} ${RISCVTOOLCHAIN_MAKEOPTS}; \
		#make install

