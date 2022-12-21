CMAKE_REV        ?= 3.23.2
CMAKE_INSTALL    := ${INSTALL_DIR}/cmake/${CMAKE_REV}
CMAKE_DIR        := ${DOWNLOAD_DIR}/cmake-${CMAKE_REV}

cmake: mkdir_install gcc openssl | ${CMAKE_INSTALL}

${CMAKE_DIR}:
	@echo "Folder ${CMAKE_DIR} does not exist"
	wget --no-check-certificate -c -P ${DOWNLOAD_DIR} https://github.com/Kitware/CMake/releases/download/v${CMAKE_REV}/cmake-${CMAKE_REV}.tar.gz
	cd ${DOWNLOAD_DIR}; tar -zxvf cmake-${CMAKE_REV}.tar.gz

${CMAKE_INSTALL}: | ${CMAKE_DIR}
	@echo "Folder ${CMAKE_INSTALL} does not exist"
	cd ${CMAKE_DIR}; \
		export OPENSSL_ROOT_DIR=${OPENSSL_INSTALL};\
		./bootstrap --prefix=${CMAKE_INSTALL} ;\
		make clean; \
		make; \
		make install;
	rm -rf ${CMAKE_DIR}
