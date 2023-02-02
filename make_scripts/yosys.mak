YOSYS_REPO     := https://github.com/YosysHQ/yosys.git
YOSYS_REV      ?= yosys-0.25
YOSYS_NAME     := yosys
YOSYS_INSTALL  := ${INSTALL_DIR}/${YOSYS_NAME}/${YOSYS_REV}
YOSYS_DIR      := ${DOWNLOAD_DIR}/yosys-git
YOSYS_RELEASE  := 0

${YOSYS_NAME}_clean:
	rm -rf ${YOSYS_INSTALL}
    
${YOSYS_NAME}: mkdir_install gcc make llvm tcl | ${YOSYS_INSTALL}

${YOSYS_DIR}:
	@echo "Folder ${YOSYS_INSTALL} does not exist"
	git clone ${YOSYS_REPO} ${YOSYS_DIR}


${YOSYS_INSTALL}: | ${YOSYS_DIR}
	@echo "Folder ${YOSYS_INSTALL} does not exist"
	if [ "${YOSYS_REV}" = "" ]; then \
		cd ${YOSYS_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${YOSYS_DIR}; \
			git fetch; \
        	git checkout -f ${YOSYS_REV};\
    fi
	mkdir -p ${YOSYS_DIR}
	cd ${YOSYS_DIR}; \
		export PATH=${LLVM_INSTALL}/bin:${TCL_INSTALL}/bin:${PATH}; \
		make clean; \
		make -j ${PROCESSOR}; \
		make install PREFIX=${YOSYS_INSTALL}
	${MAKE} ${YOSYS_NAME}_module

${YOSYS_NAME}_module: ${YOSYS_INSTALL}
	@export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export INSTALL_DIR=${INSTALL_DIR};\
	export TOOL=${YOSYS_NAME};\
	export REV=${YOSYS_REV};\
	export RELEASE=${YOSYS_RELEASE};\
		./module_setup.sh

# sudo apt-get install build-essential clang bison flex \
# 	libreadline-dev gawk tcl-dev libffi-dev git \
# 	graphviz xdot pkg-config python3 libboost-system-dev \
# 	libboost-python-dev libboost-filesystem-dev zlib1g-dev
