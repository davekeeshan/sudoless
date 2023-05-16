MODULES_REPO     := https://github.com/cea-hpc/modules.git
MODULES_REV      ?= v5.1.0
MODULES_INSTALL  := ${INSTALL_DIR}/modules/${MODULES_REV}
MODULES_DIR      := ${DOWNLOAD_DIR}/modules-git
MODULEFILE_DIR   := ${INSTALL_DIR}/../modules_config/modules_common

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
		./configure --prefix=${MODULES_INSTALL} --with-tclsh=${TCL_INSTALL}/bin/tclsh --with-tcl=${TCL_INSTALL}/lib --with-python=${PYTHON_INSTALL}/bin/python --modulefilesdir=${MODULEFILE_DIR}; \
		make clean; \
		make -j ${PROCESSOR} ; \
		make install
	${MAKE} pydeactivate

module_write:
	export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export TOOL=gcc;\
	export REV=10.4.0;\
	export RELEASE=0;\
		./module_setup.sh
