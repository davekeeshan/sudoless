#TK_REPO     := https://github.com/tcltk/tk.git
TK_REPO     := git@github.com:tcltk/tk.git
TK_REV      ?= core-8-6-12
TK_INSTALL  := ${INSTALL_DIR}/tk/${TK_REV}
TK_DIR      := ${DOWNLOAD_DIR}/tk-git

tk_clean:
	rm -rf $(TK_INSTALL)
    
tk: mkdir_install gcc make tcl | $(TK_INSTALL)

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
		make; \
		make install
	#rm -rf tk*
