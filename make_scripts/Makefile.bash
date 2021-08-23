BASH_REPO     := https://github.com/bminor/bash.git
BASH_REV      ?= bash-5.2
BASH_INSTALL  := ${INSTALL_DIR}/bash/${BASH_REV}
BASH_DIR      := ${DOWNLOAD_DIR}/bash-git

bash_clean:
	rm -rf $(BASH_INSTALL)
    
bash: mkdir_install make | $(BASH_INSTALL)

bash_install:
	@echo ${BASH_INSTALL}

${BASH_DIR}:
ifeq (${SYSTEM_BASH}, 0)
	@echo "Folder ${BASH_INSTALL} does not exist"
	git clone ${BASH_REPO} ${BASH_DIR}
endif

${BASH_INSTALL}: | ${BASH_DIR}
ifeq (${SYSTEM_BASH}, 0)
	@echo "Folder ${BASH_INSTALL} does not exist"
	if [ "${BASH_REV}" = "" ]; then \
		cd ${BASH_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${BASH_DIR}; \
			git fetch; \
        	git checkout -f ${BASH_REV};\
    fi
	mkdir -p ${BASH_DIR}
	cd ${BASH_DIR}; \
		./configure --prefix=${BASH_INSTALL} ; \
		make clean; \
		make; \
		make install
	$(MAKE) bash_link
else
	@echo "Using System Bash"
endif

bash_link:
	ln -fs $(shell ls ${BASH_INSTALL}/bin/*) ${INSTALL_DIR}/local/bin/.
