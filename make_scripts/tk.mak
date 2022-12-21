#TK_REPO     := https://github.com/tcltk/tk.git
TK_REPO     := git@github.com:tcltk/tk.git
TK_REV      ?= core-8-6-12
TK_NAME     := tk
TK_INSTALL  := ${INSTALL_DIR}/${TK_NAME}/${TK_REV}
TK_DIR      := ${DOWNLOAD_DIR}/${TK_NAME}-git
TK_RELEASE  := 0

${TK_NAME}_clean:
	rm -rf $(TK_INSTALL)
    
${TK_NAME}: mkdir_install gcc make tcl | $(TK_INSTALL)

${TK_DIR}:
	@echo "Folder ${TK_INSTALL} does not exist"
	git clone ${TK_REPO} ${TK_DIR}


${TK_INSTALL}: | ${TK_DIR}
	@echo "Folder ${TK_INSTALL} does not exist"
	if [ "${TK_REV}" = "" ]; then \
		cd ${TK_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${TK_DIR}; \
			git fetch; \
        	git checkout -f ${TK_REV};\
    fi
	cd ${TK_DIR}/unix; \
		./configure --prefix=${TK_INSTALL} --with-tcl=${TCL_INSTALL}/lib; \
		make clean ; \
		make; \
		make install

${TK_NAME}_module: ${TK_INSTALL}
	@export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export INSTALL_DIR=${INSTALL_DIR};\
	export TOOL=${TK_NAME};\
	export REV=${TK_REV};\
	export LD_LIBRARY=1;\
	export RELEASE=${TK_RELEASE};\
		bash ./module_setup.sh

