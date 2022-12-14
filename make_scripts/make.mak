MAKE_REPO       := https://git.savannah.gnu.org/git/make.git
MAKE_REV        ?= 4.3
MAKE_NAME       := make
MAKE_INSTALL    := ${INSTALL_DIR}/${MAKE_NAME}/${MAKE_REV}
MAKE_DIR        := ${DOWNLOAD_DIR}/make-git
MAKE_RELEASE    := 0
SYSTEM_MAKE     ?= 1

ifeq ($(SYSTEM_MAKE), 0)
	PATH := $(MAKE_INSTALL)/bin:${PATH}
endif

make_clean:
	rm -rf ${MAKE_INSTALL}

make: mkdir_install | ${MAKE_INSTALL}

${MAKE_INSTALL}:
ifeq (${SYSTEM_MAKE}, 0)
	@echo "Folder ${MAKE_INSTALL} does not exist"
	#curl https://ftp.gnu.org/gnu/make/make-${MAKE_REV}.tar.gz -o ${DOWNLOAD_DIR}/make-${MAKE_REV}.tar.gz
	wget --no-check-certificate -c -P ${DOWNLOAD_DIR} https://ftp.gnu.org/gnu/make/make-${MAKE_REV}.tar.gz
	cd ${DOWNLOAD_DIR}; tar -zxvf make-${MAKE_REV}.tar.gz
	cd ${DOWNLOAD_DIR}/make-${MAKE_REV}; \
		./configure --prefix=${MAKE_INSTALL}; \
		make clean; \
		make; \
		make install
	ln -s ${MAKE_INSTALL}/bin/make ${MAKE_INSTALL}/bin/gmake
	${MAKE} make_module
else
	@echo "Using System MAKE"
endif

# ${MAKE_DIR}: 
# 	@echo "Folder ${MAKE_DIR} does not exist"
# 	git clone ${MAKE_REPO} ${MAKE_DIR}
# 
# ${MAKE_INSTALL}: | ${MAKE_DIR}
# 	@echo "Folder ${MAKE_INSTALL} does not exist"
# 	if [ "${MAKE_REV}" = "" ]; then \
# 		cd ${MAKE_DIR}; \
# 			git fetch; \
#         	git checkout -f master;\
# 	else \
# 		cd ${MAKE_DIR}; \
# 			git fetch; \
#         	git checkout -f ${MAKE_REV};\
#     fi
# 	cd ${MAKE_DIR}; \
# 		export PATH=${TEXINFO_INSTALL}/bin:${PATH}; \
# 		./bootstrap; \
# 		./configure --prefix=${MAKE_INSTALL}; \
# 		make clean; \
# 		make; \
# 		make install
# 	ln -s ${MAKE_INSTALL}/bin/make ${MAKE_INSTALL}/bin/gmake
# 	$(MAKE) make_link

make_link:
	ln -fs $(shell ls ${MAKE_INSTALL}/bin/*) ${INSTALL_DIR}/local/bin/.

make_module: $(MAKE_INSTALL)
	@export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export TOOL=${MAKE_NAME};\
	export REV=${MAKE_REV};\
	export RELEASE=${MAKE_RELEASE};\
		./module_setup.sh
