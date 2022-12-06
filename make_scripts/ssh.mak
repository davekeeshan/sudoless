#SSH_REPO         := https://github.com/openssh/openssh-portable.git
SSH_REPO         := git@github.com:openssh/openssh-portable.git
SSH_REV          ?= V_9_1_P1
SSH_INSTALL      := ${INSTALL_DIR}/ssh/${SSH_REV}
SSH_DIR          := ${DOWNLOAD_DIR}/ssh-git

ssh_clean:
	rm -rf ${SSH_INSTALL}

ssh: mkdir_install gcc make | ${SSH_INSTALL}

${SSH_DIR}: 
	@echo "Folder ${SSH_DIR} does not exist"
	git clone ${SSH_REPO} ${SSH_DIR}

${SSH_INSTALL}: | ${SSH_DIR}
	@echo "Folder ${SSH_INSTALL} does not exist"
	if [ "${SSH_REV}" = "" ]; then \
		cd ${SSH_DIR}; \
			git pull; \
        	git checkout master;\
	else \
		cd ${SSH_DIR}; \
			git pull; \
        	git checkout ${SSH_REV};\
    fi
	cd ${SSH_DIR}; \
		autoreconf; \
		./configure --prefix=${SSH_INSTALL} --with-ssl-dir=${OPENSSL_INSTALL}; \
		#./configure --prefix=${SSH_INSTALL}; \
		#make clean; \
		#make; \
		#make install;

