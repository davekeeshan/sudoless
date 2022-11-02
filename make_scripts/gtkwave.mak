GTKWAVE_REPO     := https://github.com/gtkwave/gtkwave.git
GTKWAVE_HEAD     ?= ${shell git ls-remote ${GTKWAVE_REPO} | head -1 | awk '{print $$1}'}
GTKWAVE_REV      ?= ${GTKWAVE_HEAD}
#GTKWAVE_REV      ?= gtkwave-0.20
GTKWAVE_INSTALL  := ${INSTALL_DIR}/gtkwave/${GTKWAVE_REV}
GTKWAVE_DIR      := ${DOWNLOAD_DIR}/gtkwave-git

gtkwave_clean:
	rm -rf $(GTKWAVE_INSTALL)
    
gtkwave: mkdir_install gcc make | $(GTKWAVE_INSTALL)

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
		./configure --prefix=${GTKWAVE_INSTALL} --enable-gtk3 ; \
		make clean; \
		make; \
		#make install

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
