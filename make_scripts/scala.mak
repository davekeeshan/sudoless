SBT_REPO     := https://github.com/sbt/sbt.git
SBT_HEAD     ?= $(shell git ls-remote ${SBT_REPO} | head -1 | awk '{print $$1}')
#SBT_REV      ?= ${SBT_HEAD}
SBT_REV      ?= v1.7.1
SBT_INSTALL  := ${INSTALL_DIR}/sbt/${SBT_REV}
SBT_DIR      := ${DOWNLOAD_DIR}/sbt

scala_clean:
	rm -rf $(SBT_INSTALL)

scala: mkdir_install gcc make | $(GCC_INSTALL) $(MAKE_INSTALL) $(GIT_INSTALL) $(SBT_INSTALL)

# $(SBT_DIR): 
# 	@echo "Folder $(SBT_DIR) does not exist"
# 	git clone ${SBT_REPO}

$(SBT_INSTALL):
	@echo "Folder $(SBT_INSTALL) does not exist"
	./cs setup --install-dir $(SBT_INSTALL)
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
