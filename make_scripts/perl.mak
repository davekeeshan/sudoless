#!/usr/bin/env make
#PERL_REPO          := https://github.com/Perl/perl5.git
PERL_REPO          := git@github.com:Perl/perl5.git
PERL_REV           ?= v5.36.0
PERL_INSTALL       := ${INSTALL_DIR}/perl/${PERL_REV}
PERL_DIR           := ${DOWNLOAD_DIR}/perl-git
SYSTEM_PERL        ?= 1

ifeq ($(SYSTEM_PERL), 0)
	PATH := $(PERL_INSTALL)/bin:${PATH}
endif

perl_clean:
	rm -rf $(PERL_INSTALL)

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
	cd ${PERL_DIR} ; \
		sh Configure -de -Dprefix=${PERL_INSTALL}; \
		make ; \
		make install
else
	@echo "Using System perl"
endif
