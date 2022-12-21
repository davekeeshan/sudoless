GPERF_REV         ?= 3.1
GPERF_INSTALL     := ${INSTALL_DIR}/gperf/${GPERF_REV}
GPERF_DIR         := ${DOWNLOAD_DIR}/gperf-${GPERF_REV}

gperf_clean:
	rm -rf ${GPERF_INSTALL}

gperf : mkdir_install gcc | $(GPERF_INSTALL)

${GPERF_DIR}:
	@echo "Folder ${GPERF_DIR} does not exist"
	wget --no-check-certificate -c -P ${DOWNLOAD_DIR} http://ftp.gnu.org/pub/gnu/gperf/gperf-${GPERF_REV}.tar.gz
	cd ${DOWNLOAD_DIR}; tar -xf gperf-${GPERF_REV}.tar*

${GPERF_INSTALL}: | ${GPERF_DIR}
	@echo "Folder ${GPERF_INSTALL} does not exist"
	cd ${GPERF_DIR}; \
		export LD_LIBRARY_PATH=${GCC_INSTALL}/lib64; \
		./configure --prefix=${GPERF_INSTALL}; \
		make clean; \
		make -j ${PROCESSOR}; \
		make install
	rm -rf ${GPERF_DIR}
