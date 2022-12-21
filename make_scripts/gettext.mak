#GETTEXT_REPO     := https://github.com/autotools-mirror/gettext.git
GETTEXT_REPO     := git@github.com:autotools-mirror/gettext.git
GETTEXT_REV      ?= 0.21.1
GETTEXT_INSTALL  := ${INSTALL_DIR}/gettext/${GETTEXT_REV}
GETTEXT_DIR      := ${DOWNLOAD_DIR}/gettext-git

gettext_clean:
	rm -rf $(GETTEXT_INSTALL)
    
gettext_git: mkdir_install gcc make gperf gnulib autoconf | ${GETTEXT_INSTALL}_git

gettext: mkdir_install gcc make | ${GETTEXT_INSTALL}

${GETTEXT_DIR}:
	@echo "Folder ${GETTEXT_INSTALL} does not exist"
	git clone ${GETTEXT_REPO} ${GETTEXT_DIR}


${GETTEXT_INSTALL}_git: | ${GETTEXT_DIR}
	@echo "Folder ${GETTEXT_INSTALL} does not exist"
	if [ "${GETTEXT_REV}" = "" ]; then \
		cd ${GETTEXT_DIR}; \
			git fetch; \
			git checkout -f master;\
	else \
		cd ${GETTEXT_DIR}; \
			git fetch; \
			git checkout -f ${GETTEXT_REV};\
	fi
	mkdir -p ${GETTEXT_DIR}
	cd ${GETTEXT_DIR}; \
		export PATH=${AUTOCONF_INSTALL}/bin:${TEXINFO_INSTALL}/bin:${PATH}; \
		./autogen.sh ; \
		./configure --prefix=${GETTEXT_INSTALL} ; \
		make clean; \
		make; \
		make install
		
${DOWNLOAD_DIR}/gettext-${GETTEXT_REV}.tar.gz:
	@echo "Folder ${GETTEXT_DIR} does not exist"
	wget --no-check-certificate -c -P ${DOWNLOAD_DIR} https://ftp.gnu.org/pub/gnu/gettext/gettext-${GETTEXT_REV}.tar.gz
	cd ${DOWNLOAD_DIR}; tar -xf gettext-${GETTEXT_REV}.tar*

${GETTEXT_INSTALL}: | ${DOWNLOAD_DIR}/gettext-${GETTEXT_REV}.tar.gz
	@echo "Folder ${GETTEXT_INSTALL} does not exist"
	cd ${DOWNLOAD_DIR}/gettext-${GETTEXT_REV}; \
		./configure --prefix=${GETTEXT_INSTALL}; \
		make clean; \
		make; \
		make install
	rm -rf 	${DOWNLOAD_DIR}/gettext-${GETTEXT_REV}	
