INKSCAPE_REPO       := https://gitlab.com/inkscape/inkscape.git
INKSCAPE_REV        ?= INKSCAPE_1_2_1
INKSCAPE_INSTALL    := ${INSTALL_DIR}/inkscape/${INKSCAPE_REV}
INKSCAPE_DIR        := ${DOWNLOAD_DIR}/inkscape-git

inkscape_clean:
	rm -rf ${INKSCAPE_INSTALL}

inkscape: mkdir_install cmake | ${INKSCAPE_INSTALL}

${INKSCAPE_DIR}: 
	@echo "Folder ${INKSCAPE_DIR} does not exist"
	git clone ${INKSCAPE_REPO} ${INKSCAPE_DIR}

${INKSCAPE_INSTALL}: | ${INKSCAPE_DIR}
	@echo "Folder ${INKSCAPE_INSTALL} does not exist"
	if [ "${INKSCAPE_REV}" = "" ]; then \
		cd ${INKSCAPE_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${INKSCAPE_DIR}; \
			git fetch; \
        	git checkout -f ${INKSCAPE_REV};\
    fi
	mkdir -p ${INKSCAPE_DIR}/build; \
	cd ${INKSCAPE_DIR}/build; \
		export PATH=${CMAKE_INSTALL}/bin:${PATH}; \
		export LD_LIBRARY_PATH=$(GCC_INSTALL)/lib64:${LD_LIBRARY_PATH}; \
		cmake ..; \
		make ; \
# mkdir build
#  1130  cd build
#  1131  cmake ..
#  1132  make
# 		stack setup; \
# 		stack install --local-bin-path ${INKSCAPE_INSTALL}/bin
# 	$(MAKE) inkscape_link

inkscape_link:
	ln -fs $(shell ls ${INKSCAPE_INSTALL}/bin/*) ${INSTALL_DIR}/local/bin/.
