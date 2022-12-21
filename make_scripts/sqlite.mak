SQLITE_REV        ?= 3.39.1
SQLITE_INSTALL    := ${INSTALL_DIR}/sqlite/${SQLITE_REV}
SQLITE_DIR        := ${DOWNLOAD_DIR}/sqlite-${SQLITE_REV}

sqlite_clean:
	rm -rf $(SQLITE_INSTALL)

sqlite: mkdir_install gcc tcl | $(SQLITE_INSTALL)

$(SQLITE_DIR):
	@echo "Folder $(SQLITE_DIR) does not exist"
	rm -rf sqlite*
	wget --no-check-certificate  -c -P ${DOWNLOAD_DIR} https://www.sqlite.org/src/tarball/sqlite.tar.gz
	cd ${DOWNLOAD_DIR}; tar -zxvf sqlite.tar.gz
	cd ${DOWNLOAD_DIR}; mv sqlite ${SQLITE_DIR}

$(SQLITE_INSTALL):| $(SQLITE_DIR)
	@echo "Folder $(SQLITE_INSTALL) does not exist"
	cd ${SQLITE_DIR}; \
		export PATH=$(TCL_INSTALL)/bin:${PATH}; \
                mkdir -p build; \
		cd build; \
			../configure --prefix=${SQLITE_INSTALL} ; \
			make clean; \
			make; \
			make sqlite3.c; \
 			make install
		rm -rf ${SQLITE_DIR}
