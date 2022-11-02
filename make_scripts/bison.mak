BISON_REPO        := https://github.com/akimd/bison.git
BISON_REV         ?= 3.8.2
BISON_INSTALL     := ${INSTALL_DIR}/bison/${BISON_REV}
#BISON_DIR         := ${DOWNLOAD_DIR}/bison-git
BISON_DIR         := ${DOWNLOAD_DIR}/bison-${BISON_REV}

bison_clean:
	rm -rf ${BISON_INSTALL}

bison: mkdir_install gcc make | ${BISON_INSTALL}

# ${BISON_DIR}:
# 	@echo "Folder ${BISON_DIR} does not exist"
# 	export PATH=${GIT_INSTALL}/bin:${PATH}; \
# 		git clone ${BISON_REPO} ${BISON_DIR}
# 
# ${BISON_INSTALL}: | ${BISON_DIR}
# 	@echo "Folder ${BISON_INSTALL} does not exist"
# 	if [ "${BISON_REV}" = "" ]; then \
# 		cd ${BISON_DIR}; \
# 			git fetch; \
#         	git checkout -f master;\
# 	else \
# 		cd ${BISON_DIR}; \
# 			git fetch; \
#         	git checkout -f ${BISON_REV};\
#     fi
# 	cd ${BISON_DIR}; \
# 		./bootstrap --skip-po; \
# 		./configure --prefix=${BISON_INSTALL}; \
# 		make; \
# 		make install
# 
${BISON_DIR}:
	@echo "Folder ${BISON_DIR} does not exist"
	rm -rf bison*
	wget --no-check-certificate -c -P ${DOWNLOAD_DIR} https://ftp.gnu.org/gnu/bison/bison-${BISON_REV}.tar.gz
	cd ${DOWNLOAD_DIR}; tar -zxvf bison-${BISON_REV}.tar*

${BISON_INSTALL}: | ${BISON_DIR}
	@echo "Folder ${BISON_INSTALL} does not exist"
	cd ${BISON_DIR}; \
		./configure --prefix=${BISON_INSTALL}; \
		make clean; \
		make; \
		make install
