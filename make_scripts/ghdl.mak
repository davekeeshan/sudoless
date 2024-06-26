# make ghdl
# make GHDL_REV=v0.35 GCC_REV=7.5.0 ghdl_gcc 
# make GHDL_REV=v0.36 GCC_REV=8.4.0 ghdl_gcc 
# make GHDL_REV=v0.37 GCC_REV=10.4.0 ghdl_gcc 
# make GHDL_REV=v1.0.0 GCC_REV=10.4.0 ghdl_gcc 
# make GHDL_REV=v2.0.0 GCC_REV=10.4.0 ghdl_gcc 
GHDL_REPO          := https://github.com/ghdl/ghdl.git
GHDL_HEAD          ?= ${shell git ls-remote ${GHDL_REPO} | head -1 | awk '{print $$1}'}
GHDL_REV           ?= ${GHDL_HEAD}
#GHDL_REV           ?= v2.0.0
GHDL_LLVM_INSTALL  := ${INSTALL_DIR}/ghdl-llvm/${GHDL_REV}
GHDL_MCODE_INSTALL := ${INSTALL_DIR}/ghdl-mcode/${GHDL_REV}
GHDL_GCC_NAME      := ghdl-gcc
GHDL_GCC_INSTALL   := ${INSTALL_DIR}/${GHDL_GCC_NAME}/${GHDL_REV}
GHDL_GCC_RELEASE   := 0
GHDL_DIR           := ${DOWNLOAD_DIR}/${GHDL_GCC_NAME}-git

${GHDL_DIR}: 
	@echo "Folder ${GHDL_DIR} does not exist"
	git clone ${GHDL_REPO} ${GHDL_DIR}

ghdl_git:| ${GHDL_DIR}
	if [ "${GHDL_REV}" = "" ]; then \
		cd ${GHDL_DIR}; \
			git fetch; \
                        git checkout -f master;\
	else \
		cd ${GHDL_DIR}; \
			git fetch; \
                        git checkout -f ${GHDL_REV};\
        fi

ghdl_mcode_clean:
	rm -rf ${GHDL_MCODE_INSTALL}

ghdl_mcode: mkdir_install gcc make | ${GHDL_MCODE_INSTALL}


${GHDL_MCODE_INSTALL}: ghdl_git
	@echo "Folder ${GHDL_MCODE_INSTALL} does not exist"
	cd ${GHDL_DIR}; \
		./configure --prefix=${GHDL_MCODE_INSTALL}; \
		make clean; \
		make -j ${PROCESSOR}; \
		make install        
     
ghdl_llvm_clean:
	rm -rf ${GHDL_LLVM_INSTALL}

ghdl_llvm: mkdir_install gcc make llvm | ${GHDL_LLVM_INSTALL}


${GHDL_LLVM_INSTALL}: ghdl_git
	@echo "Folder ${GHDL_LLVM_INSTALL} does not exist"
	mkdir -p ${GHDL_DIR}/ghdl-objs
	cd ${GHDL_DIR}/ghdl-objs; \
		export PATH=${LLVM_INSTALL}/bin:${PATH}; \
		which llvm-config ; \
		../configure --with-llvm-config --prefix=${GHDL_LLVM_INSTALL}; \
		make clean; \
		make; \
# 		make install        
# 		export LD_LIBRARY_PATH=${GCC_INSTALL}/lib64:${GLIBC_INSTALL}/lib; \
# 		llvm-config; \
    
${GHDL_GCC_NAME}_clean:
	rm -rf ${GHDL_GCC_INSTALL}

${GHDL_GCC_NAME}: mkdir_install make texinfo | ${GHDL_GCC_INSTALL}

${GHDL_GCC_INSTALL}: gcc_git ghdl_git
	@echo "Folder ${GHDL_GCC_INSTALL} does not exist"
	rm -rf ${GHDL_DIR}/build
	mkdir -p ${GHDL_DIR}/build
	cd ${GHDL_DIR}/build; \
		export PATH=${GNAT_INSTALL}/bin:${TEXINFO_INSTALL}/bin:${PATH}; \
		../configure --with-gcc=${GCC_DIR} --prefix=${GHDL_GCC_INSTALL}; \
		make copy-sources
	mkdir -p ${GHDL_DIR}/build/gcc-objs
	cd ${GHDL_DIR}/build/gcc-objs; \
		export PATH=${GNAT_INSTALL}/bin:${TEXINFO_INSTALL}/bin:${PATH}; \
		${GCC_DIR}/configure \
			--prefix=${GHDL_GCC_INSTALL} \
			--enable-languages=c,vhdl \
			--disable-bootstrap \
			--disable-lto \
			--disable-multilib \
			--disable-libssp \
			--disable-libgomp \
			--disable-libquadmath; \
		make -j ${PROCESSOR}; \
        make install
	cd ${GHDL_DIR}/build; \
		make ghdllib; \
		make install
	$(MAKE) ${GHDL_GCC_NAME}_module

${GHDL_GCC_NAME}_module: ${GHDL_GCC_INSTALL}
	@export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export INSTALL_DIR=${INSTALL_DIR};\
	export TOOL=${GHDL_GCC_NAME};\
	export REV=${GHDL_REV};\
	export LD_LIBRARY=1;\
	export RELEASE=${GHDL_GCC_RELEASE};\
		bash ./module_setup.sh

