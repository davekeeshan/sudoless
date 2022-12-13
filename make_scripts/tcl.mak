#TCL_REPO     := https://github.com/tcltk/tcl.git
TCL_REPO     := git@github.com:tcltk/tcl.git
TCL_REV      ?= core-8-6-12
TCL_INSTALL  := ${INSTALL_DIR}/tcl/${TCL_REV}
TCL_DIR      := ${DOWNLOAD_DIR}/tcl-git

tcl_clean:
	rm -rf $(TCL_INSTALL)
    
tcl: mkdir_install gcc make | $(TCL_INSTALL)

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

tcl_link:
	ln -s ${TCL_INSTALL}/bin/tclsh* ${TCL_INSTALL}/bin/tclsh 
