CWD            ?= ${PWD}
BASE_PATH      ?= ${PATH}
INSTALL_DIR    ?= ${HOME}/local/tools
VENV_DIR       ?= ${HOME}/local/venv
DOWNLOAD_DIR   ?= ${CWD}/downloads
SCRIPTS_DIR    ?= ${CWD}
PROCESSOR      ?= 8

#LD_LIBRARY_PATH := ""

include ${SCRIPTS_DIR}/*.mak

LD_LIBRARY_PATH := ${INSTALL_DIR}/local/lib:${LD_LIBRARY_PATH}

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
