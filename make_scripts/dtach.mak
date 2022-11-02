DTACH_REPO        := https://github.com/crigler/dtach.git
#DTACH_HEAD        ?= $(shell git ls-remote ${DTACH_REPO} | head -1 | awk '{print $$1}')
#DTACH_REV         ?= ${DTACH_HEAD}
DTACH_REV         ?= v0.9
DTACH_INSTALL     := ${INSTALL_DIR}/dtach/${DTACH_REV}
DTACH_DIR         := ${DOWNLOAD_DIR}/dtach-git

dtach_clean:
	rm -rf ${DTACH_INSTALL}

dtach: mkdir_install gcc make | ${DTACH_INSTALL}

${DTACH_DIR}: 
	@echo "Folder ${DTACH_DIR} does not exist"
	git clone ${DTACH_REPO} ${DTACH_DIR}

${DTACH_INSTALL}: | ${DTACH_DIR}
	@echo "Folder ${DTACH_INSTALL} does not exist"
	if [ "${DTACH_REV}" = "" ]; then \
		cd ${DTACH_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${DTACH_DIR}; \
			git fetch; \
        	git checkout -f ${DTACH_REV};\
    fi
	cd ${DTACH_DIR}; \
		./configure; \
		make clean; \
		make ; \
        mkdir -p ${DTACH_INSTALL}/bin; \
        cp dtach ${DTACH_INSTALL}/bin/.
	$(MAKE) dtach_link

dtach_link:
	ln -fs $(shell ls ${DTACH_INSTALL}/bin/*) ${INSTALL_DIR}/local/bin/.
