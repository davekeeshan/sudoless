READLINE_REPO     := https://git.savannah.gnu.org/git/readline.git
READLINE_REV      ?= readline-8.2
READLINE_NAME     := readline
READLINE_INSTALL  := ${INSTALL_DIR}/${READLINE_NAME}/${READLINE_REV}
READLINE_DIR      := ${DOWNLOAD_DIR}/readline-git
READLINE_RELEASE  := 0

${READLINE_NAME}_clean:
	rm -rf ${READLINE_INSTALL}
    
${READLINE_NAME}: mkdir_install gcc make llvm tcl | ${READLINE_INSTALL}

${READLINE_DIR}:
	@echo "Folder ${READLINE_INSTALL} does not exist"
	git clone ${READLINE_REPO} ${READLINE_DIR}


${READLINE_INSTALL}: | ${READLINE_DIR}
	@echo "Folder ${READLINE_INSTALL} does not exist"
	if [ "${READLINE_REV}" = "" ]; then \
		cd ${READLINE_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${READLINE_DIR}; \
			git fetch; \
        	git checkout -f ${READLINE_REV};\
	fi
	cd ${READLINE_DIR}; \
		./configure --prefix=${READLINE_INSTALL}; \
		make clean; \
		make -j ${PROCESSOR}; \
		make install
