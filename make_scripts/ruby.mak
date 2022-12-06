RUBY_REV        ?= 2.6.10
RUBY_INSTALL    := ${INSTALL_DIR}/ruby/${RUBY_REV}
RUBY_DIR        := ${DOWNLOAD_DIR}/ruby-${RUBY_REV}

ruby: mkdir_install gcc make wget openssl | $(RUBY_INSTALL)

ruby_clean:
	rm -rf $(RUBY_INSTALL)

$(RUBY_DIR):
	@echo "Folder $(RUBY_DIR) does not exist"
	wget --no-check-certificate -c -P ${DOWNLOAD_DIR} https://cache.ruby-lang.org/pub/ruby/2.6/ruby-${RUBY_REV}.tar.gz
	cd ${DOWNLOAD_DIR} ; tar -zxvf ruby-${RUBY_REV}.tar.gz

$(RUBY_INSTALL): | $(RUBY_DIR)
	@echo "Folder $(RUBY_INSTALL) does not exist"
	cd ${RUBY_DIR}; \
		export PATH=$(GCC_INSTALL)/bin:$(MAKE_INSTALL)/bin:${PATH}; \
		./configure --prefix=${RUBY_INSTALL} --with-openssl-dir=${OPENSSL_INSTALL} ;\
		make; \
		make install	
	#$(MAKE) ruby_link

ruby_link:
	ln -fs $(shell ls ${RUBY_INSTALL}/bin/*) ${INSTALL_DIR}/local/lib/.
