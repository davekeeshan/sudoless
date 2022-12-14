# make iverilog_clean iverilog
# make iverilog_clean iverilog IVERILOG_REV=v11_0
# make iverilog IVERILOG_REV=v10_3 BISON_REV=3.3.2 GCC_REV=10.4.0
# make iverilog_clean iverilog GCC_REV=8.5.0
#IVERILOG_REPO     := https://github.com/steveicarus/iverilog.git
IVERILOG_REPO     := git@github.com:steveicarus/iverilog.git
IVERILOG_HEAD     ?= $(shell git ls-remote ${IVERILOG_REPO} | head -1 | awk '{print $$1}')
IVERILOG_REV      ?= ${IVERILOG_HEAD}
#IVERILOG_REV      ?= v11_0
IVERILOG_NAME     := iverilog
IVERILOG_INSTALL  := ${INSTALL_DIR}/${IVERILOG_NAME}/${IVERILOG_REV}
IVERILOG_DIR      := ${DOWNLOAD_DIR}/iverilog-git
IVERILOG_RELEASE  := 0

iverilog_clean:
	rm -rf ${IVERILOG_INSTALL}

iverilog: mkdir_install gcc gperf bison flex | $(IVERILOG_INSTALL)

${IVERILOG_DIR}: 
	@echo "Folder ${IVERILOG_DIR} does not exist"
	git clone ${IVERILOG_REPO} ${IVERILOG_DIR}

$(IVERILOG_INSTALL): | ${IVERILOG_DIR}
	@echo "Folder $(IVERILOG_INSTALL) does not exist"
	if [ "${IVERILOG_REV}" = "" ]; then \
		cd ${IVERILOG_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${IVERILOG_DIR}; \
			git fetch; \
        	git checkout -f ${IVERILOG_REV};\
    fi
	echo ${GCC_INSTALL}
	cd ${IVERILOG_DIR}; \
		export PATH=${GPERF_INSTALL}/bin:${FLEX_INSTALL}/bin:${BISON_INSTALL}/bin:${PATH}; \
		make clean; \
		rm -rf configure; \
		autoconf; \
		./configure --prefix=${IVERILOG_INSTALL}; \
		make -j ${PROCESSOR}; \
		make install      
	${MAKE} iverilog_module

iverilog_module:
	@export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export TOOL=${IVERILOG_NAME};\
	export REV=${IVERILOG_REV};\
	export RELEASE=${IVERILOG_RELEASE};\
		./module_setup.sh
