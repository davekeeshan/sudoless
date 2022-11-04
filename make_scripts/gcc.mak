GCC_REPO           := https://github.com/gcc-mirror/gcc.git
GCC_REV            ?= 12.1.0
GCC_INSTALL        := ${INSTALL_DIR}/gcc/${GCC_REV}
GCC_DIR            := ${DOWNLOAD_DIR}/gcc-git
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
	cd ${GCC_DIR} ; \
		rm -rf mpfr* gmp* mpc* isl*; \
		./contrib/download_prerequisites
	rm -rf ${GCC_DIR}/objdir
	mkdir -p ${GCC_DIR}/objdir
	cd ${GCC_DIR}/objdir ; \
		export PATH=${GNAT_INSTALL}/bin:${PATH}; \
		../configure \
			--disable-multilib \
			--enable-languages=c,c++ \
			--prefix=${GCC_INSTALL}; \
		make clean;\
		make;\
		make install
	rm -rf ${GCC_DIR}/objdir
endif
