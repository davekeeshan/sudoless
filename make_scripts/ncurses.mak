NCURSES_REPO     := https://github.com/mirror/ncurses.git
NCURSES_REV      ?= v6.3
NCURSES_INSTALL  := ${INSTALL_DIR}/ncurses/${NCURSES_REV}
NCURSES_DIR      := ${DOWNLOAD_DIR}/ncurses-git

ncurses_clean:
	rm -rf $(NCURSES_INSTALL)
    
ncurses: mkdir_install gcc make | $(NCURSES_INSTALL)

${NCURSES_DIR}:
	@echo "Folder ${NCURSES_INSTALL} does not exist"
	git clone ${NCURSES_REPO} ${NCURSES_DIR}


${NCURSES_INSTALL}: | ${NCURSES_DIR}
	@echo "Folder ${NCURSES_INSTALL} does not exist"
	if [ "${NCURSES_REV}" = "" ]; then \
		cd ${NCURSES_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${NCURSES_DIR}; \
			git fetch; \
        	git checkout -f ${NCURSES_REV};\
    fi
	mkdir -p ${NCURSES_DIR}/objdir
	cd ${NCURSES_DIR}/objdir; \
		export PATH=$(MAKE_INSTALL)/bin:${GCC_INSTALL}/bin:${PATH}; \
		../configure --with-install-prefix=${NCURSES_INSTALL}; \
		make clean; \
		make; \
		make install


#		../configure --with-install-prefix=${NCURSES_INSTALL}; \
