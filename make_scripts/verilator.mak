# Use this commmand
# make verilator FLEX_REV=flex-2.5.39
VERILATOR_REPO     := https://github.com/verilator/verilator.git
# VERILATOR_HEAD     ?= $(shell git ls-remote ${VERILATOR_REPO} | head -1 | awk '{print $$1}')
# VERILATOR_REV      ?= ${VERILATOR_HEAD}
VERILATOR_REV      ?= v5.002
VERILATOR_NAME     := verilator
VERILATOR_INSTALL  := ${INSTALL_DIR}/${VERILATOR_NAME}/${VERILATOR_REV}
VERILATOR_DIR      := ${DOWNLOAD_DIR}/verilator-git
VERILATOR_RELEASE  := 0

${VERILATOR_NAME}_clean:
	rm -rf ${VERILATOR_INSTALL}

${VERILATOR_NAME}: mkdir_install gcc bison flex python | ${VERILATOR_INSTALL}

${VERILATOR_DIR}: 
	@echo "Folder ${VERILATOR_DIR} does not exist"
	git clone ${VERILATOR_REPO} ${VERILATOR_DIR}

${VERILATOR_INSTALL}: | ${VERILATOR_DIR}
	@echo "Folder $(VERILATOR_INSTALL) does not exist"
	if [ "${VERILATOR_REV}" = "" ]; then \
		cd ${VERILATOR_DIR}; \
			git fetch; \
                        git checkout -f master;\
	else \
		cd ${VERILATOR_DIR}; \
			git fetch; \
                        git checkout -f ${VERILATOR_REV};\
                fi
	cd ${VERILATOR_DIR}; \
		export PATH=${FLEX_INSTALL}/bin:${BISON_INSTALL}/bin:${PATH}; \
		autoconf; \
		./configure --prefix=${VERILATOR_INSTALL}; \
		make clean; \
		make -j ${PROCESSOR}; \
		make install        
	$(MAKE) ${VERILATOR_NAME}_module
     
${VERILATOR_NAME}_module: ${VERILATOR_INSTALL}
	@export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export INSTALL_DIR=${INSTALL_DIR};\
	export TOOL=${VERILATOR_NAME};\
	export REV=${VERILATOR_REV};\
	export LD_LIBRARY=1;\
	export RELEASE=${VERILATOR_RELEASE};\
		bash ./module_setup.sh
