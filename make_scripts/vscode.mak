VSCODE_REPO     := https://github.com/microsoft/vscode.git
VSCODE_REV      ?= 1.72.2
VSCODE_INSTALL  := ${INSTALL_DIR}/vscode/${VSCODE_REV}
VSCODE_DIR      := ${DOWNLOAD_DIR}/vscode-git

vscode_clean:
	rm -rf $(VSCODE_INSTALL)
    
vscode: mkdir_install make | $(VSCODE_INSTALL)

vscode_install:
	@echo ${VSCODE_INSTALL}

${VSCODE_DIR}:
	@echo "Folder ${VSCODE_INSTALL} does not exist"
	git clone ${VSCODE_REPO} ${VSCODE_DIR}

${VSCODE_INSTALL}: | ${VSCODE_DIR}
	@echo "Folder ${VSCODE_INSTALL} does not exist"
	if [ "${VSCODE_REV}" = "" ]; then \
		cd ${VSCODE_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${VSCODE_DIR}; \
			git fetch; \
        	git checkout -f ${VSCODE_REV};\
    fi
	mkdir -p ${VSCODE_DIR}
	cd ${VSCODE_DIR}; \
# 		./configure --prefix=${VSCODE_INSTALL} ; \
# 		make clean; \
# 		make; \
# 		make install
# 	$(MAKE) vscode_link
# 
# 
# vscode_link:
# 	ln -fs $(shell ls ${VSCODE_INSTALL}/bin/*) ${INSTALL_DIR}/local/bin/.
