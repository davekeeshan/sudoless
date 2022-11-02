GLIB_REPO     := https://github.com/GNOME/glib.git
GLIB_REV      ?= 2.73.2
GLIB_INSTALL  := ${INSTALL_DIR}/glib/${GLIB_REV}
GLIB_DIR      := ${DOWNLOAD_DIR}/glib-git

glib_clean:
	rm -rf $(GLIB_INSTALL)
    
glib: mkdir_install gcc cmake pyactivate | $(GLIB_INSTALL)

${GLIB_DIR}:
	@echo "Folder ${GLIB_INSTALL} does not exist"
	git clone ${GLIB_REPO} ${GLIB_DIR}


${GLIB_INSTALL}: | ${GLIB_DIR}
	@echo "Folder ${GLIB_INSTALL} does not exist"
	if [ "${GLIB_REV}" = "" ]; then \
		cd ${GLIB_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${GLIB_DIR}; \
			git fetch; \
        	git checkout -f ${GLIB_REV};\
    fi
	mkdir -p ${GLIB_DIR}
	cd ${GLIB_DIR}; \
		export PATH=${VENV_PATH}/bin:${CMAKE_INSTALL}/bin:${PATH}; \
		pip install -U meson ninja; \
		meson setup --prefix=${GLIB_INSTALL} _build; \
# 		ninja -C _build ; \
# 		ninja -C _build install
# # 	${MAKE} pydeactivate
