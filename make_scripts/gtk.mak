GTK_REPO     := https://github.com/GNOME/gtk.git
# GTK_HEAD     ?= ${shell git ls-remote ${GTK_REPO} | head -1 | awk '{print $$1}'}4.8.0
# GTK_REV      ?= ${GTK_HEAD}
GTK_REV      ?= 4.8.0
GTK_INSTALL  := ${INSTALL_DIR}/gtk/${GTK_REV}
GTK_DIR      := ${DOWNLOAD_DIR}/gtk-git

gtk_clean:
	rm -rf $(GTK_INSTALL)
    
gtk: mkdir_install pyactivate | $(GTK_INSTALL)

${GTK_DIR}:
	@echo "Folder ${GTK_INSTALL} does not exist"
	git clone ${GTK_REPO} ${GTK_DIR}


${GTK_INSTALL}: | ${GTK_DIR}
	@echo "Folder ${GTK_INSTALL} does not exist"
	if [ "${GTK_REV}" = "" ]; then \
		cd ${GTK_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${GTK_DIR}; \
			git fetch; \
        	git checkout -f ${GTK_REV};\
    fi
	mkdir -p ${GTK_DIR}
	cd ${GTK_DIR}; \
		export PATH=${VENV_PATH}/bin:${WGET_INSTALL}/bin:${PATH}; \
		pip install -U meson ninja jinja2 markdown markupsafe pygments toml typogrify; \
		rm -rf _build; \
		git checkout _build;\
		meson _build .; \
# 		./autogen.sh; \
# 		./configure --prefix=${GTK_INSTALL} --enable-gtk3 ; \
# 		make clean; \
# 		make; \
# 		#make install
	${MAKE} pydeactivate
