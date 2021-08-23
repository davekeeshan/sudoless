GNULIB_REPO     := https://git.savannah.gnu.org/git/gnulib.git
GNULIB_REV      ?= master
GNULIB_INSTALL  := ${INSTALL_DIR}/gnulib/${GNULIB_REV}
GNULIB_DIR      := ${DOWNLOAD_DIR}/gnulib-git

gnulib_clean:
	rm -rf $(GNULIB_INSTALL)
    
gnulib: mkdir_install gcc make gperf | ${GNULIB_INSTALL}

${GNULIB_DIR}:
	@echo "Folder ${GNULIB_INSTALL} does not exist"
	git clone ${GNULIB_REPO} ${GNULIB_DIR}


${GNULIB_INSTALL}: | ${GNULIB_DIR}
	@echo "Folder ${GNULIB_INSTALL} does not exist"
	if [ "${GNULIB_REV}" = "" ]; then \
		cd ${GNULIB_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${GNULIB_DIR}; \
			git fetch; \
        	git checkout -f ${GNULIB_REV};\
    fi
	mkdir -p ${GNULIB_INSTALL}/bin
	ln -fs $(shell ls ${GNULIB_DIR}/gnulib-tool) ${GNULIB_INSTALL}/bin/.
	ln -fs $(shell ls ${GNULIB_DIR}/gnulib-tool.py) ${GNULIB_INSTALL}/bin/.


gnulib_link:
	ln -fs $(shell ls ${GNULIB_INSTALL}/bin/*) ${INSTALL_DIR}/local/bin/.

