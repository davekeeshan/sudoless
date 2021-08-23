STACK_REPO       := https://github.com/commercialhaskell/stack.git
STACK_REV        ?= 2.7.5
STACK_INSTALL    := ${INSTALL_DIR}/stack/${STACK_REV}
STACK_DIR        := ${DOWNLOAD_DIR}/stack-git

stack_clean:
	rm -rf ${STACK_INSTALL}

stack: mkdir_install gcc make | ${STACK_INSTALL}

${STACK_DIR}: 
	@echo "Folder ${STACK_DIR} does not exist"
	git clone ${STACK_REPO} ${STACK_DIR}

${STACK_INSTALL}: | ${STACK_DIR}
	@echo "Folder ${STACK_INSTALL} does not exist"
	if [ "${STACK_REV}" = "" ]; then \
		cd ${STACK_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${STACK_DIR}; \
			git fetch; \
        	git checkout -f v${STACK_REV};\
    fi
	cd ${STACK_DIR}; \
# 		make clean; \
# 		make; \
# 		make install prefix=${STACK_INSTALL}

	$(MAKE) stack_link

stack_link:
	ln -fs $(shell ls ${STACK_INSTALL}/bin/*) ${INSTALL_DIR}/local/bin/.

stack_release:
	rm -rf ${STACK_INSTALL}*/
	wget -c https://github.com/commercialhaskell/stack/releases/download/v${STACK_REV}/stack-${STACK_REV}-linux-x86_64-static.tar.gz	
	tar -zxvf stack-${STACK_REV}-linux-x86_64-static.tar.gz
	mkdir -p ${STACK_INSTALL}/bin; \
    cp stack-${STACK_REV}*/stack ${STACK_INSTALL}/bin/.
	$(MAKE) stack_link
