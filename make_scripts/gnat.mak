GNAT_REV           ?= 2015
GNAT_INSTALL       ?= ${INSTALL_DIR}/gnat/${GNAT_REV}
GNAT_DIR           := ${DOWNLOAD_DIR}/gnat-${GNAT_REV}

gnat_clean:
	rm -rf ${GNAT_INSTALL}

gnat: mkdir_install gcc make | ${GNAT_INSTALL}

${GNAT_DIR}:
	@echo "Folder ${GNAT_DIR} does not exist"
	wget --no-check-certificate -c https://community.download.adacore.com/v1/f3a99d283f7b3d07293b2e1d07de00e31e332325?filename=gnat-2021-20210519-x86_64-linux-bin -O ${DOWNLOAD_DIR}/gnat-2021-20210519-x86_64-linux-bin
	chmod +x ${DOWNLOAD_DIR}/gnat-2021-20210519-x86_64-linux-bin
    
${GNAT_INSTALL}: | ${GNAT_DIR}
	@echo "Folder ${GNAT_INSTALL} does not exist"
	${DOWNLOAD_DIR}/gnat-2021-20210519-x86_64-linux-bin

# 	cd ${GNAT_DIR}; \
# 		./configure --prefix=${GNAT_INSTALL}; \
# 		make clean; \
# 		make; \
# 		make install
# gnat: | ${GNAT_INSTALL}
# 
# ${GNAT_INSTALL}:
# 	@echo "Folder ${GNAT_INSTALL} does not exist"
# 	@echo "This needs to be installed from the website first:"
# 	@echo "    https://www.adacore.com/download/more"
# 	@exit 1
# 
# https://community.download.adacore.com/v1/636d019a16eddc4457f1b29f4b2d2a5a21a98450?filename=gnat-2021-20210519-riscv32-elf-linux64-bin&rand=1633
# 
