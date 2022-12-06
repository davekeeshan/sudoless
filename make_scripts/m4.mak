M4_REV        ?= 1.4.19
M4_INSTALL    := ${INSTALL_DIR}/m4/${M4_REV}
M4_DIR        := ${DOWNLOAD_DIR}/m4-${M4_REV}

m4_clean:
	rm -rf $(M4_INSTALL)

m4: mkdir_install gcc tcl | $(M4_INSTALL)

$(M4_DIR):
	@echo "Folder $(M4_DIR) does not exist"
	rm -rf m4*
	wget --no-check-certificate  -c -P ${DOWNLOAD_DIR} https://ftp.gnu.org/gnu/m4/m4-${M4_REV}.tar.gz
	cd ${DOWNLOAD_DIR}; tar -zxvf m4-${M4_REV}.tar.gz

$(M4_INSTALL):| $(M4_DIR)
	@echo "Folder $(M4_INSTALL) does not exist"
	cd ${M4_DIR}; \
		./configure --prefix=${M4_INSTALL} ; \
		make clean; \
		make; \
 		make install
