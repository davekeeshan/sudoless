CWD            ?= ${PWD}
BASE_PATH      ?= ${PATH}
INSTALL_DIR    ?= ${HOME}/local/tools
VENV_DIR       ?= ${HOME}/local/venv
DOWNLOAD_DIR   ?= ${CWD}/downloads
SCRIPTS_DIR    ?= ${CWD}
PROCESSOR      ?= 8
SYSTEM_GCC     ?= 1
#SYSTEM_MAKE    ?= 1
#SYSTEM_BASH    ?= 1
#SYSTEM_GIT     ?= 1
#SYSTEM_CURL    ?= 1
#SYSTEM_PERL    ?= 1
SYSTEM_PYTHON  ?= 1


include ${SCRIPTS_DIR}/Makefile.*

LD_LIBRARY_PATH := ${INSTALL_DIR}/local/lib:${LD_LIBRARY_PATH}
ifeq ($(SYSTEM_GCC), 0)
	PATH := $(GCC_INSTALL)/bin:${PATH}
	LD_LIBRARY_PATH := $(GCC_INSTALL)/lib64:${LD_LIBRARY_PATH}
endif
# ifeq ($(SYSTEM_MAKE), 0)
# 	PATH := $(MAKE_INSTALL)/bin:${PATH}
# endif
# ifeq ($(SYSTEM_BASH), 0)
# 	PATH := $(BASH_INSTALL)/bin:${PATH}
# endif
# ifeq ($(SYSTEM_GIT), 0)
# 	PATH := $(GIT_INSTALL)/bin:${PATH}
# endif
# ifeq ($(SYSTEM_CURL), 0)
# 	PATH := $(CURL_INSTALL)/bin:${PATH}
# endif
# ifeq ($(SYSTEM_PERL), 0)
# 	PATH := $(PERL_INSTALL)/bin:${PATH}
# endif
ifeq ($(SYSTEM_PYTHON), 0)
	PATH := $(PYTHON_INSTALL)/bin:${PATH}
	LD_LIBRARY_PATH := $(PYTHON_INSTALL)/lib:${LD_LIBRARY_PATH}
# else
# 	LD_LIBRARY_PATH := /projects/flow/tools/x86_64-rocky8/python/v3.10.7/lib:${LD_LIBRARY_PATH}
# 	#LD_LIBRARY_PATH := $(shell which python)/../../lib:${LD_LIBRARY_PATH}
endif
export LD_LIBRARY_PATH

mkdir_install:
	@mkdir -p ${INSTALL_DIR}
	@mkdir -p ${DOWNLOAD_DIR}
	@mkdir -p ${INSTALL_DIR}/local/lib
	@mkdir -p ${INSTALL_DIR}/local/bin

git_fetch:
	if [ "${TAG_REV}" = "" ]; then \
		cd ${TAG_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${TAG_DIR}; \
			git fetch; \
        	git checkout -f ${TAG_REV};\
    fi

git_clone: 
	@echo "Folder ${TAG_DIR} does not exist"
	git clone ${TAG_REPO} ${TAG_DIR}

report_paths:
	@echo "PATH ${PATH}"
	@echo "LD_LIBRARY_PATH ${LD_LIBRARY_PATH}"
	@which gcc ; gcc --version | grep ^gcc | sed 's/^.* //g'
	@which make ; make --version | grep "^GNU Make" | sed 's/^.* //g'
	@which bash ; bash --version | head -n 1 | awk '{ print $$4 }'
	@which git ; git --version | grep "^git" | sed 's/^.* //g'
	@which curl ; curl --version | head -n 1 | awk '{ print $$2 }'
	@which perl ; perl -e 'print $$]' ; echo ""
	@which python ; python --version | grep ^Python | sed 's/^.* //g'
