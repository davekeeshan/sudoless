CMAKE_REPO       := https://github.com/Kitware/CMake.git
CMAKE_REV        ?= v3.25.2
CMAKE_NAME       := cmake
CMAKE_INSTALL    := ${INSTALL_DIR}/${CMAKE_NAME}/${CMAKE_REV}
CMAKE_DIR        := ${DOWNLOAD_DIR}/cmake-git

${CMAKE_NAME}_clean:
	rm -rf ${CMAKE_INSTALL}

${CMAKE_NAME}: mkdir_install gcc make openssl | ${CMAKE_INSTALL}

${CMAKE_DIR}:
	@echo "Folder ${CMAKE_INSTALL} does not exist"
	git clone ${CMAKE_REPO} ${CMAKE_DIR}

# ${CMAKE_DIR}:
# 	@echo "Folder ${CMAKE_DIR} does not exist"
# 	wget --no-check-certificate -c -P ${DOWNLOAD_DIR} https://github.com/Kitware/CMake/releases/download/v${CMAKE_REV}/cmake-${CMAKE_REV}.tar.gz
# 	cd ${DOWNLOAD_DIR}; tar -zxvf cmake-${CMAKE_REV}.tar.gz

${CMAKE_INSTALL}: | ${CMAKE_DIR}
	@echo "Folder ${CMAKE_INSTALL} does not exist"
	if [ "${CMAKE_REV}" = "" ]; then \
		cd ${CMAKE_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${CMAKE_DIR}; \
			git fetch; \
        	git checkout -f ${CMAKE_REV};\
    fi
	cd ${CMAKE_DIR}; \
		export OPENSSL_ROOT_DIR=${OPENSSL_INSTALL};\
		./bootstrap --prefix=${CMAKE_INSTALL} ;\
		make clean; \
		make -j ${PROCESSOR}; \
		make install;
