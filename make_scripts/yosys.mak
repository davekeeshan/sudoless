YOSYS_REPO     := https://github.com/YosysHQ/yosys.git
YOSYS_REV      ?= yosys-0.20
YOSYS_INSTALL  := ${INSTALL_DIR}/yosys/${YOSYS_REV}
YOSYS_DIR      := ${DOWNLOAD_DIR}/yosys-git

yosys_clean:
	rm -rf $(YOSYS_INSTALL)
    
yosys: mkdir_install gcc make | $(YOSYS_INSTALL)

${YOSYS_DIR}:
	@echo "Folder ${YOSYS_INSTALL} does not exist"
	git clone ${YOSYS_REPO} ${YOSYS_DIR}


${YOSYS_INSTALL}: | ${YOSYS_DIR}
	@echo "Folder ${YOSYS_INSTALL} does not exist"
	if [ "${YOSYS_REV}" = "" ]; then \
		cd ${YOSYS_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${YOSYS_DIR}; \
			git fetch; \
        	git checkout -f ${YOSYS_REV};\
    fi
	mkdir -p ${YOSYS_DIR}
	cd ${YOSYS_DIR}; \
		export PATH=${LLVM_INSTALL}/bin:$(MAKE_INSTALL)/bin:${GCC_INSTALL}/bin:${PATH}; \
		export LD_LIBRARY_PATH=${GCC_INSTALL}/lib64; \
		make clean; \
		make; \
		#make install
#		./configure --prefix=${YOSYS_INSTALL} ; \
