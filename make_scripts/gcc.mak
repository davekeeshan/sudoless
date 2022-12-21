#GCC_REPO           := https://github.com/gcc-mirror/gcc.git
GCC_REPO           := git@github.com:gcc-mirror/gcc.git
GCC_REV            ?= 12.1.0
GCC_NAME           := gcc
GCC_INSTALL        := ${INSTALL_DIR}/${GCC_NAME}/${GCC_REV}
GCC_DIR            := ${DOWNLOAD_DIR}/${GCC_NAME}-git
GCC_RELEASE        := 0
SYSTEM_GCC         ?= 1

ifeq ($(SYSTEM_GCC), 0)
	PATH := $(GCC_INSTALL)/bin:${PATH}
	LD_LIBRARY_PATH := $(GCC_INSTALL)/lib64:${LD_LIBRARY_PATH}
endif

gcc_git: | ${GCC_DIR}
	if [ "${GCC_REV}" = "" ]; then \
		cd ${GCC_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${GCC_DIR}; \
			git fetch; \
        	git checkout -f releases/gcc-${GCC_REV};\
    fi

gcc_install:
	@echo ${GCC_INSTALL}

gcc_clean:
	rm -rf $(GCC_INSTALL)

gcc: mkdir_install | ${GCC_INSTALL}

${GCC_DIR}:
ifeq (${SYSTEM_GCC}, 0)
	@echo "Folder ${GCC_DIR} does not exist"
	git clone ${GCC_REPO} ${GCC_DIR}
endif

${GCC_INSTALL}: | ${GCC_DIR}
ifeq (${SYSTEM_GCC}, 1)
	@echo "Using System GCC"
else
	@echo "Folder ${GCC_INSTALL} does not exist"
	$(MAKE) gcc_git;
	rm -rf ${GCC_DIR}/objdir
	mkdir -p ${GCC_DIR}/objdir
	cd ${GCC_DIR} ; \
		rm -rf mpfr* gmp* mpc* isl*; \
		./contrib/download_prerequisites
	cd ${GCC_DIR}/objdir ; \
		export PATH=${GNAT_INSTALL}/bin:${PATH}; \
		../configure \
			--disable-multilib \
			--enable-languages=c,c++,ada \
			--prefix=${GCC_INSTALL}; \
		make clean;\
		make -j ${PROCESSOR}; \
		make install
	rm -rf ${GCC_DIR}/objdir
	$(MAKE) ${GCC_NAME}_module
endif

${GCC_NAME}_module: ${GCC_INSTALL}
	@export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export INSTALL_DIR=${INSTALL_DIR};\
	export TOOL=${GCC_NAME};\
	export REV=${GCC_REV};\
	export LD_LIBRARY=1;\
	export RELEASE=${GCC_RELEASE};\
		./module_setup.sh
