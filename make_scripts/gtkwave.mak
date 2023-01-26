GTKWAVE_REPO     := https://github.com/gtkwave/gtkwave.git
GTKWAVE_HEAD     ?= ${shell git ls-remote ${GTKWAVE_REPO} | head -1 | awk '{print $$1}'}
GTKWAVE_REV      ?= ${GTKWAVE_HEAD}
#GTKWAVE_REV      ?= gtkwave-0.20
GTKWAVE_NAME     := gtkwave
GTKWAVE_INSTALL  := ${INSTALL_DIR}/${GTKWAVE_NAME}/${GTKWAVE_REV}
GTKWAVE_DIR      := ${DOWNLOAD_DIR}/gtkwave-git
GTKWAVE_RELEASE  := 0

${GTKWAVE_NAME}_clean:
	rm -rf $(GTKWAVE_INSTALL)
    
${GTKWAVE_NAME}: mkdir_install gcc make tcl tk | $(GTKWAVE_INSTALL)

${GTKWAVE_DIR}:
	@echo "Folder ${GTKWAVE_INSTALL} does not exist"
	git clone ${GTKWAVE_REPO} ${GTKWAVE_DIR}


${GTKWAVE_INSTALL}: | ${GTKWAVE_DIR}
	@echo "Folder ${GTKWAVE_INSTALL} does not exist"
	if [ "${GTKWAVE_REV}" = "" ]; then \
		cd ${GTKWAVE_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${GTKWAVE_DIR}; \
			git fetch; \
        	git checkout -f ${GTKWAVE_REV};\
    fi
	mkdir -p ${GTKWAVE_DIR}/gtkwave3-gtk3
	cd ${GTKWAVE_DIR}/gtkwave3-gtk3; \
		export PATH=$(GPERF_INSTALL)/bin:${PATH}; \
		./autogen.sh; \
		./configure --prefix=${GTKWAVE_INSTALL} \
			--enable-gtk3 \
			--with-tcl=${TCL_INSTALL}/lib \
			--with-tk=${TK_INSTALL}/lib; \
		make clean; \
		make -j ${PROCESSOR}; \
		make install

${GTKWAVE_NAME}_module: ${GTKWAVE_INSTALL}
	@export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export INSTALL_DIR=${INSTALL_DIR};\
	export TOOL=${GTKWAVE_NAME};\
	export REV=${GTKWAVE_REV};\
	export EXTRA_OPTS="    prepend-path     LD_LIBRARY_PATH ${TCL_INSTALL}/lib\n    prepend-path     LD_LIBRARY_PATH ${TK_INSTALL}/lib";\
	export RELEASE=${GTKWAVE_RELEASE};\
		bash ./module_setup.sh

# checking for GTK... no
# configure: error: Package requirements (gtk+-3.0 >= 3.0.0) were not met:
# 
# Package 'gtk+-3.0', required by 'virtual:world', not found
# 
# Consider adjusting the PKG_CONFIG_PATH environment variable if you
# installed software in a non-standard prefix.
# 
# Alternatively, you may set the environment variables GTK_CFLAGS
# and GTK_LIBS to avoid the need to call pkg-config.
# See the pkg-config man page for more details.
