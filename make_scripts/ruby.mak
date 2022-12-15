RUBY_REPO       := https://github.com/ruby/ruby.git
#RUBY_REPO       := git@github.com:ruby/ruby.git
RUBY_REV        ?= v3_1_3
RUBY_INSTALL    := ${INSTALL_DIR}/ruby/${RUBY_REV}
RUBY_DIR        := ${DOWNLOAD_DIR}/ruby-git

LD_LIBRARY_PATH := ${OPENSSL_INSTALL}/lib:${LD_LIBRARY_PATH}

ruby: mkdir_install gcc make openssl autoconf libffi | $(RUBY_INSTALL)

ruby_clean:
	rm -rf $(RUBY_INSTALL)

${RUBY_DIR}:
	@echo "Folder ${RUBY_INSTALL} does not exist"
	git clone ${RUBY_REPO} ${RUBY_DIR}

${RUBY_INSTALL}: | ${RUBY_DIR}
	@echo "Folder ${RUBY_INSTALL} does not exist"
	if [ "${RUBY_REV}" = "" ]; then \
		cd ${RUBY_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${RUBY_DIR}; \
			git fetch; \
        	git checkout -f ${RUBY_REV};\
    fi
	rm -rf ${RUBY_DIR}/build
	mkdir -p ${RUBY_DIR}/build
	cd ${RUBY_DIR}; \
		export PATH=${AUTOCONF_INSTALL}/bin:${PATH}; \
		export LDFLAGS="-L${LIBFFI_INSTALL}/lib64"; \
		./autogen.sh; \
		cd build; \
			../configure --prefix=${RUBY_INSTALL} --with-openssl-dir=${OPENSSL_INSTALL} ;\
			make clean ; \
			make -j ${PROCESSOR} ; \
			make install	
	$(MAKE) ruby_link

ruby_link:
	ln -fs $(shell ls ${RUBY_INSTALL}/bin/*) ${INSTALL_DIR}/local/lib/.
