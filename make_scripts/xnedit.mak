XNEDIT_REPO        := https://github.com/unixwork/xnedit.git
XNEDIT_REV         ?= v1.4.1
XNEDIT_INSTALL     := ${INSTALL_DIR}/xnedit/${XNEDIT_REV}
XNEDIT_DIR         := ${DOWNLOAD_DIR}/xnedit-git

xnedit_clean:
	rm -rf ${XNEDIT_INSTALL}

xnedit: mkdir_install gcc make | $(XNEDIT_INSTALL)

${XNEDIT_DIR}:
	@echo "Folder ${XNEDIT_DIR} does not exist"
	git clone ${XNEDIT_REPO} ${XNEDIT_DIR}

${XNEDIT_INSTALL}: | ${XNEDIT_DIR}
	@echo "Folder ${XNEDIT_INSTALL} does not exist"
	if [ "${XNEDIT_REV}" = "" ]; then \
		cd ${XNEDIT_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${XNEDIT_DIR}; \
			git fetch; \
        	git checkout -f ${XNEDIT_REV};\
    fi
	cd ${XNEDIT_DIR}; \
		make clean; \
		make linux; \
#         mkdir -p $(XNEDIT_INSTALL); \
#         cp xnedit $(XNEDIT_INSTALL)/.
