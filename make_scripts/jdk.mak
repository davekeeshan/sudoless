JDK_REPO         := https://github.com/openjdk/jdk
JDK_REV          ?= jdk-20+16
JDK_DIR          := ${DOWNLOAD_DIR}/jdk-git
JDK_RELEASE      := 19
#JDK_INSTALL      := ${INSTALL_DIR}/jdk/${JDK_REV}
JDK_INSTALL      := ${INSTALL_DIR}/jdk/${JDK_RELEASE}

jdk_clean:
	rm -rf ${JDK_INSTALL}

jdk: mkdir_install gcc | ${JDK_INSTALL}

${JDK_DIR}: 
	@echo "Folder ${JDK_DIR} does not exist"
	git clone ${JDK_REPO} ${JDK_DIR}

${JDK_INSTALL}: | ${JDK_DIR}
	@echo "Folder ${JDK_INSTALL} does not exist"
	if [ "${JDK_REV}" = "" ]; then \
		cd ${JDK_DIR}; \
			git pull; \
        	git checkout master;\
	else \
		cd ${JDK_DIR}; \
			git pull; \
        	git checkout ${JDK_REV};\
    fi
	cd ${JDK_DIR}; \
		export PATH=${BASH_INSTALL}/bin:${PATH}; \
		bash configure --with-boot-jdk=/projects/flow/tools/compile/jdk-19 --prefix=${JDK_INSTALL}; \
# 		export LD_LIBRARY_PATH=$(GCC_INSTALL)/lib64:${INSTALL_DIR}/local/lib; \
# 		./autogen.sh; \
# 		make clean; \
# 		make; \
# 		make install        

jdk_release:
	mkdir -p ${INSTALL_DIR}/jdk
	rm -rf jdk-${JDK_RELEASE}*
	wget --no-check-certificate  https://download.java.net/java/GA/jdk19/877d6127e982470ba2a7faa31cc93d04/36/GPL/openjdk-19_linux-x64_bin.tar.gz
	tar -zxvf openjdk-19_linux-x64_bin.tar.gz
	cp -r jdk-${JDK_RELEASE} ${JDK_INSTALL}
