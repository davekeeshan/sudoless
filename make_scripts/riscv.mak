RISCV_REPO     := https://github.com/riscv/riscv-gnu-toolchain
RISCV_REV      ?= f2a2c87
RISCV_INSTALL  := ${INSTALL_DIR}/riscv/${RISCV_REV}
RISCV_DIR      := ${DOWNLOAD_DIR}/riscv-git

riscv_clean:
	rm -rf $(RISCV_INSTALL)
    
riscv: mkdir_install make texinfo | $(RISCV_INSTALL)

${RISCV_DIR}:
	@echo "Folder ${RISCV_INSTALL} does not exist"
	git clone ${RISCV_REPO} ${RISCV_DIR}

${RISCV_INSTALL}: | ${RISCV_DIR}
	@echo "Folder ${RISCV_INSTALL} does not exist"
	if [ "${RISCV_REV}" = "" ]; then \
		cd ${RISCV_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${RISCV_DIR}; \
			git fetch; \
        	git checkout -f ${RISCV_REV};\
    fi
	rm -rf ${RISCV_DIR}/build
	mkdir -p ${RISCV_DIR}/build
	cd ${RISCV_DIR}/build; \
		export PATH=${RISCV_INSTALL}/bin:${TEXINFO_INSTALL}/bin:${PATH}; \
		../configure --prefix=${RISCV_INSTALL} ; \
		make clean; \
		make -j$(nproc); \
		#make install

