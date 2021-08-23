RUBY_REV        ?= 3.1.2
RUBY_INSTALL    := ${INSTALL_DIR}/ruby/${RUBY_REV}
RUBY_DIR        := ${DOWNLOAD_DIR}/ruby-${RUBY_REV}

ruby: mkdir_install gcc | $(RUBY_INSTALL) $(GCC_INSTALL) $(MAKE_INSTALL) $(OPENSSL_INSTALL)

$(RUBY_DIR):
	@echo "Folder $(RUBY_DIR) does not exist"
	wget --no-check-certificate https://cache.ruby-lang.org/pub/ruby/3.1/ruby-${RUBY_REV}.tar.gz
	tar -zxvf ruby-${RUBY_REV}.tar.gz

$(RUBY_INSTALL): | $(RUBY_DIR)
	@echo "Folder $(RUBY_INSTALL) does not exist"
	cd ${RUBY_DIR}; \
		export PATH=$(GCC_INSTALL)/bin:$(MAKE_INSTALL)/bin:${PATH}; \
		./configure --prefix=${RUBY_INSTALL} --with-openssl-dir=$(OPENSSL_INSTALL) ;\
		make; \
		make install
