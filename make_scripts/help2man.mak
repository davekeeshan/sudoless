HELP2MAN_REV      ?= 1.49.2
HELP2MAN_INSTALL  := ${INSTALL_DIR}/help2man/${HELP2MAN_REV}

help2man: mkdir_install gcc make | $(HELP2MAN_INSTALL)

$(HELP2MAN_INSTALL):
	@echo "Folder $(HELP2MAN_INSTALL) does not exist"
	rm -rf help2man*
	wget --no-check-certificate http://ftp.snt.utwente.nl/pub/software/gnu/help2man/help2man-${HELP2MAN_REV}.tar.xz
	tar -xf help2man-${HELP2MAN_REV}.tar.xz
	cd help2man-${HELP2MAN_REV}; \
		export PATH=$(MAKE_INSTALL)/bin:$(GCC_INSTALL)/bin:${PATH}; \
		./configure --prefix=${HELP2MAN_INSTALL}; \
		make; \
		make install
	rm -rf help2man*
