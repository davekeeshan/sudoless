LLVM_REPO     := https://github.com/llvm/llvm-project.git
LLVM_REV      ?= llvmorg-15.0.7
LLVM_NAME     := llvm
LLVM_INSTALL  := ${INSTALL_DIR}/${LLVM_NAME}/${LLVM_REV}
LLVM_DIR      := ${DOWNLOAD_DIR}/llvm-git

${LLVM_NAME}_clean:
	rm -rf ${LLVM_INSTALL}
    
${LLVM_NAME}: mkdir_install gcc cmake make | ${LLVM_INSTALL}

${LLVM_DIR}:
	@echo "Folder ${LLVM_INSTALL} does not exist"
	git clone ${LLVM_REPO} ${LLVM_DIR}

${LLVM_INSTALL}: | ${LLVM_DIR}
	@echo "Folder ${LLVM_INSTALL} does not exist"
	if [ "${LLVM_REV}" = "" ]; then \
		cd ${LLVM_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${LLVM_DIR}; \
			git fetch; \
        	git checkout -f ${LLVM_REV};\
    fi
	mkdir -p ${LLVM_DIR}
	cd ${LLVM_DIR}; \
		export PATH=${CMAKE_INSTALL}/bin:${PATH}; \
		rm -rf build/ ; \
		mkdir build; \
		cmake -S llvm -B build -G "Unix Makefiles" -DLLVM_ENABLE_PROJECTS=clang -DCMAKE_INSTALL_PREFIX=${LLVM_INSTALL} -DCMAKE_BUILD_TYPE=Release; \
		cd build; \
		make clean; \
		make -j ${PROCESSOR}; \
		make install

# CMake Warning (dev) at /projects/flow/tools/x86_64-centos7/cmake/3.23.2/share/cmake-3.23/Modules/GNUInstallDirs.cmake:241 (message):
#   Unable to determine default CMAKE_INSTALL_LIBDIR directory because no
#   target architecture is known.  Please enable at least one language before
#   including GNUInstallDirs.
# Call Stack (most recent call first):
#   /projects/flow/tools/compile/llvm-git/llvm/cmake/modules/LLVMInstallSymlink.cmake:5 (include)
#   tools/llvm-ar/cmake_install.cmake:56 (include)
#   tools/cmake_install.cmake:49 (include)
#   cmake_install.cmake:77 (include)
# This warning is for project developers.  Use -Wno-dev to suppress it.
