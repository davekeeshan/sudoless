GVIM_REPO       := https://github.com/vim/vim.git
GVIM_REV        ?= v9.0.0463
GVIM_INSTALL    := ${INSTALL_DIR}/gvim/${GVIM_REV}
GVIM_DIR        := ${DOWNLOAD_DIR}/gvim-git

gvim_clean:
	rm -rf ${GVIM_INSTALL}

gvim: mkdir_install gcc make | ${GVIM_INSTALL}

${GVIM_DIR}: 
	@echo "Folder ${GVIM_DIR} does not exist"
	git clone ${GVIM_REPO} ${GVIM_DIR}

${GVIM_INSTALL}: | ${GVIM_DIR}
	@echo "Folder ${GVIM_INSTALL} does not exist"
	if [ "${GVIM_REV}" = "" ]; then \
		cd ${GVIM_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${GVIM_DIR}; \
			git fetch; \
        	git checkout -f ${GVIM_REV};\
    fi
	cd ${GVIM_DIR}; \
		export CFLAGS="-I${LIBX11_INSTALL}/include -I${LIBXT_INSTALL}/include -I${LIBSM_INSTALL}/include"; \
		export LIBS="-L${LIBX11_INSTALL}/lib -L${LIBXT_INSTALL}/lib -L${LIBSM_INSTALL}/lib"; \
		make distclean ;\
		./configure --prefix=${GVIM_INSTALL} --enable-gui=auto | grep "X..."  ; \
		#make clean; \
		#make; \
		#make install
        #-with-x=yes
