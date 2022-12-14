#!/usr/bin/env make
PERL_REPO          := https://github.com/Perl/perl5.git
#PERL_REPO          := git@github.com:Perl/perl5.git
PERL_REV           ?= v5.37.6
PERL_NAME          := perl
PERL_INSTALL       := ${INSTALL_DIR}/${PERL_NAME}/${PERL_REV}
PERL_DIR           := ${DOWNLOAD_DIR}/perl-git
SYSTEM_PERL        ?= 1

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
	if [ "${PERL_REV}" = "" ]; then \
		cd ${PERL_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${PERL_DIR}; \
			git fetch; \
        	git checkout -f ${PERL_REV};\
    fi
	#rm -rf ${PERL_DIR}/build
	#mkdir -p ${PERL_DIR}/build
	cd ${PERL_DIR} ; \
		sh ./Configure -de -Dprefix=${PERL_INSTALL} -Dusedevel; \
		make -j ${PROCESSOR}; \
		make install
		ln -s ${PERL_INSTALL}/bin/perl[0-9]* ${PERL_INSTALL}/bin/perl
		ln -s ${PERL_INSTALL}/bin/cpan[0-9]* ${PERL_INSTALL}/bin/cpan
else
	@echo "Using System perl"
endif

perl_module:
	@export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export TOOL=${PERL_NAME};\
	export REV=${PERL_REV};\
	export RELEASE=${PERL_RELEASE};\
		./module_setup.sh