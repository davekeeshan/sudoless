#!/usr/bin/env make
#PERL_REPO          := https://github.com/Perl/perl5.git
PERL_REPO          := git@github.com:Perl/perl5.git
PERL_REV           ?= v5.37.6
PERL_NAME          := perl
PERL_INSTALL       := ${INSTALL_DIR}/${PERL_NAME}/${PERL_REV}
PERL_DIR           := ${DOWNLOAD_DIR}/perl-git
PERL_RELEASE       := 0

ifeq ($(SYSTEM_PERL), 0)
	PATH := ${PERL_INSTALL}/bin:${PATH}
endif

perl_clean:
	rm -rf ${PERL_INSTALL}

perl: mkdir_install gcc make | ${PERL_INSTALL}

${PERL_DIR}: 
ifeq (${SYSTEM_PERL}, 0)
	@echo "Folder ${PERL_DIR} does not exist"
	git clone ${PERL_REPO} ${PERL_DIR}
endif

${PERL_INSTALL}: | ${PERL_DIR}
ifeq (${SYSTEM_PERL}, 0)
	@echo "Folder ${PERL_INSTALL} does not exist"
	cd ${PERL_DIR}; rm -rf *
	if [ "${PERL_REV}" = "" ]; then \
		cd ${PERL_DIR}; \
			git fetch; \
			git checkout -f master;\
	else \
		cd ${PERL_DIR}; \
			git fetch; \
			git checkout -f ${PERL_REV};\
    fi
	rm -rf ${PERL_DIR}_copy
	cp -rf ${PERL_DIR} ${PERL_DIR}_copy
	#rm -rf ${PERL_DIR}/build
	#mkdir -p ${PERL_DIR}/build
	cd ${PERL_DIR}_copy ; \
		sh ./Configure -de -Dprefix=${PERL_INSTALL} -Dusedevel; \
		make -j ${PROCESSOR}; \
		make install
		ln -s ${PERL_INSTALL}/bin/perl[0-9]* ${PERL_INSTALL}/bin/perl
		ln -s ${PERL_INSTALL}/bin/cpan[0-9]* ${PERL_INSTALL}/bin/cpan
	${MAKE} perl_module
	rm -rf ${PERL_DIR}_copy
else
	@echo "Using System perl"
endif

perl_module: ${PERL_INSTALL}
	@export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export INSTALL_DIR=${INSTALL_DIR};\
	export TOOL=${PERL_NAME};\
	export REV=${PERL_REV};\
	export RELEASE=${PERL_RELEASE};\
		bash ./module_setup.sh
