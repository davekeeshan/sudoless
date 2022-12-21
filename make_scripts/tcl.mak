#TCL_REPO     := https://github.com/tcltk/tcl.git
TCL_REPO     := git@github.com:tcltk/tcl.git
TCL_REV      ?= core-8-6-12
TCL_NAME     := tcl
TCL_INSTALL  := ${INSTALL_DIR}/${TCL_NAME}/${TCL_REV}
TCL_DIR      := ${DOWNLOAD_DIR}/${TCL_NAME}-git
TCL_RELEASE  := 0

${TCL_NAME}_clean:
	rm -rf $(TCL_INSTALL)
    
${TCL_NAME}: mkdir_install gcc make | $(TCL_INSTALL)

${TCL_DIR}:
	@echo "Folder ${TCL_INSTALL} does not exist"
	git clone ${TCL_REPO} ${TCL_DIR}

${TCL_INSTALL}: | ${TCL_DIR}
	@echo "Folder ${TCL_INSTALL} does not exist"
	if [ "${TCL_REV}" = "" ]; then \
		cd ${TCL_DIR}; \
			git fetch; \
                        git checkout -f master;\
	else \
		cd ${TCL_DIR}; \
			git fetch; \
                        git checkout -f ${TCL_REV};\
        fi
	cd ${TCL_DIR}/unix; \
		./configure --prefix=${TCL_INSTALL}; \
		make clean ; \
		make -j ${PROCESSOR} ; \
		make install
	${MAKE} tcl_link
	
${TCL_NAME}_link:
	ln -s ${TCL_INSTALL}/bin/tclsh* ${TCL_INSTALL}/bin/tclsh 

${TCL_NAME}_module: ${TCL_INSTALL}
	@export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export INSTALL_DIR=${INSTALL_DIR};\
	export TOOL=${TCL_NAME};\
	export REV=${TCL_REV};\
	export LD_LIBRARY=1;\
	export RELEASE=${TCL_RELEASE};\
		bash ./module_setup.sh

