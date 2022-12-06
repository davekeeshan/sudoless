MODULES_REPO     := https://github.com/cea-hpc/modules.git
MODULES_REV      ?= v5.2.0
MODULES_INSTALL  := ${INSTALL_DIR}/modules/${MODULES_REV}
MODULES_DIR      := ${DOWNLOAD_DIR}/modules-git

modules_clean:
	rm -rf $(MODULES_INSTALL)
    
modules: mkdir_install make autoconf tcl python pyactivate | $(MODULES_INSTALL)

${MODULES_DIR}:
	@echo "Folder ${MODULES_INSTALL} does not exist"
	git clone ${MODULES_REPO} ${MODULES_DIR}

${MODULES_INSTALL}: | ${MODULES_DIR}
	@echo "Folder ${MODULES_INSTALL} does not exist"
	if [ "${MODULES_REV}" = "" ]; then \
		cd ${MODULES_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${MODULES_DIR}; \
			git fetch; \
        	git checkout -f ${MODULES_REV};\
    fi
	cd ${MODULES_DIR}; \
		export PATH=${VENV_PATH}/bin:${AUTOCONF_INSTALL}/bin:${PATH}; \
		pip install sphinx; \
		./configure --prefix=${MODULES_INSTALL} --with-tclsh=${TCL_INSTALL}/bin/tclsh --with-tcl=${TCL_INSTALL}/lib --with-python=${VENV_PATH}/bin/python; \
		make clean; \
		make -j ${PROCESSOR} ; \
		make install
	${MAKE} pydeactivate
