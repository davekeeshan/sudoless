#GIT_REPO           := https://github.com/git/git.git
GIT_REPO           := git@github.com:git/git.git
GIT_REV            ?= v2.38.1
GIT_INSTALL        := ${INSTALL_DIR}/git/${GIT_REV}
GIT_DIR            := ${DOWNLOAD_DIR}/git-git
SYSTEM_GIT         ?= 1

ifeq ($(SYSTEM_GIT), 0)
	PATH := $(GIT_INSTALL)/bin:${PATH}
endif

git_clean:
	rm -rf ${GIT_INSTALL}

git: mkdir_install pyactivate gcc make xmlto | ${GIT_INSTALL}

${GIT_DIR}: 
ifeq (${SYSTEM_GIT}, 0)
	@echo "Folder ${GIT_DIR} does not exist"
	git clone ${GIT_REPO} ${GIT_DIR}
endif

${GIT_INSTALL}: | ${GIT_DIR}
ifeq (${SYSTEM_GIT}, 0)
	@echo "Folder ${GIT_INSTALL} does not exist"
	if [ "${GIT_REV}" = "" ]; then \
		cd ${GIT_DIR}; \
			git fetch; \
        	git checkout -f ${GIT_REV};\
        	git checkout -f ${GIT_REV};\
	else \
		cd ${GIT_DIR}; \
			git fetch; \
        	git checkout -f ${GIT_REV};\
    fi
	cd ${GIT_DIR}; \
		export PATH=${VENV_PATH}/bin:${XMLTO_INSTALL}/bin:${PATH}; \
		export LD_LIBRARY_PATH=${INSTALL_DIR}/local/lib; \
		pip install asciidoc; \
		make configure; \
		./configure --prefix=${GIT_INSTALL} --with-openssl=${OPENSSL_INSTALL}; \
		make clean; \
		make all ; \
		make install        
	${MAKE} pydeactivate
	${MAKE} git_link
else
	@echo "Using System GIT"
endif

git_link:
	ln -fs $(shell ls ${GIT_INSTALL}/bin/*) ${INSTALL_DIR}/local/bin/.

