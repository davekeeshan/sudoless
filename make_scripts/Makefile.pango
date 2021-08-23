PANGO_REPO       := https://gitlab.gnome.org/GNOME/pango.git
PANGO_REV        ?= 1.50.9
PANGO_INSTALL    := ${INSTALL_DIR}/pango/${PANGO_REV}
PANGO_DIR        := ${DOWNLOAD_DIR}/pango-git

pango_clean:
	rm -rf ${PANGO_INSTALL}

pango: mkdir_install pyactivate | ${PANGO_INSTALL}

${PANGO_DIR}: 
	@echo "Folder ${PANGO_DIR} does not exist"
	git clone ${PANGO_REPO} ${PANGO_DIR}

${PANGO_INSTALL}: | ${PANGO_DIR}
	@echo "Folder ${PANGO_INSTALL} does not exist"
	if [ "${PANGO_REV}" = "" ]; then \
		cd ${PANGO_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${PANGO_DIR}; \
			git fetch; \
        	git checkout -f ${PANGO_REV};\
    fi
	mkdir -p ${PANGO_DIR}; \
	cd ${PANGO_DIR}; \
		export PATH=${VENV_PATH}/bin:${CMAKE_INSTALL}/bin:${PATH}; \
		export CC=${GCC_INSTALL}/bin/gcc; \
		pip install -U meson ninja jinja2 markdown markupsafe pygments toml typogrify; \
		meson setup --wipe build; \
        meson setup --prefix=${PANGO_INSTALL} build; \
		ninja -C build ; \
		#meson setup -Dgtk_doc=true --force-fallback-for gi-docgen .; \
# 		cmake ..; \
# 		make ; 
	${MAKE} pydeactivate
# mkdir build
#  1130  cd build
#  1131  cmake ..
#  1132  make
# 		stack setup; \
# 		stack install --local-bin-path ${PANGO_INSTALL}/bin
# 	$(MAKE) pango_link

pango_link:
	ln -fs $(shell ls ${PANGO_INSTALL}/bin/*) ${INSTALL_DIR}/local/bin/.
