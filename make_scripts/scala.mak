SBT_REPO     := https://github.com/sbt/sbt.git
#SBT_HEAD     ?= $(shell git ls-remote ${SBT_REPO} | head -1 | awk '{print $$1}')
#SBT_REV      ?= ${SBT_HEAD}
SBT_REV      ?= v1.7.1
SBT_INSTALL  := ${INSTALL_DIR}/sbt/${SBT_REV}
SBT_DIR      := ${DOWNLOAD_DIR}/sbt

scala_clean:
	rm -rf ${SBT_INSTALL}

scala: mkdir_install | ${SBT_INSTALL}

${SBT_DIR}: 
	@echo "Folder ${SBT_DIR} does not exist"
	wget --no-check-certificate -c https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz -O ${DOWNLOAD_DIR}/cs-x86_64-pc-linux.gz
	cd ${DOWNLOAD_DIR} ; rm -rf cs ;  gunzip -f cs-x86_64-pc-linux.gz ; mv cs-x86_64-pc-linux cs ; chmod +x cs
	

${SBT_INSTALL}: | ${SBT_DIR}
	@echo "Folder ${SBT_INSTALL} does not exist"
	${DOWNLOAD_DIR}/cs setup --install-dir ${SBT_INSTALL}/bin


# 	if [ "${SBT_REV}" = "" ]; then \
# 		cd ${SBT_DIR}; \
# 			export PATH=$(GIT_INSTALL)/bin:${PATH};\
# 			git pull; \
#         	git checkout master;\
# 	else \
# 		cd ${SBT_DIR}; \
# 			export PATH=$(GIT_INSTALL)/bin:${PATH};\
# 			git pull; \
#         	git checkout ${SBT_REV};\
#     fi
# 	cd ${SBT_DIR}; \
# 		export PATH=$(GCC_INSTALL)/bin:$(MAKE_INSTALL)/bin:${PATH};\
# 		./configure --prefix=$(SBT_INSTALL); \
# 		make clean; \
# 		make ; \
# # 		#make install        
