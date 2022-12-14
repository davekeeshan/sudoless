GO_REPO        := https://go.googlesource.com/go
GO_REV         ?= go1.19.4
GO_REV_RELEASE ?= go1.19.3
GO_INSTALL     := ${INSTALL_DIR}/go/${GO_REV}
GO_DIR         := ${DOWNLOAD_DIR}/go-git
GO_RELEASE     := ${INSTALL_DIR}/go/${GO_REV_RELEASE}_release

go_clean:
	rm -rf ${GO_INSTALL}
	rm -rf ${GO_RELEASE}

go: mkdir_install gcc make | ${GO_INSTALL}

${GO_DIR}: | ${GO_RELEASE}
	@echo "Folder ${GO_DIR} does not exist"
	git clone ${GO_REPO} ${GO_DIR}

${GO_INSTALL}: | ${GO_DIR}
	@echo "Folder ${GO_INSTALL} does not exist"
	if [ "${GO_REV}" = "" ]; then \
		cd ${GO_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${GO_DIR}; \
			git fetch; \
        	git checkout -f ${GO_REV};\
    fi
	cd ${GO_DIR}/src; \
		export PATH=${GO_RELEASE}/bin:${PATH}; \
		./all.bash; \
		mkdir -p ${GO_INSTALL}; \
		cp -r ../bin ${GO_INSTALL}/bin
	$(MAKE) go_link

go_link:
	ln -fs $(shell ls ${GO_INSTALL}/bin/*) ${INSTALL_DIR}/local/bin/.

${GO_RELEASE}: go_release

go_release:
	wget --no-check-certificate -c -P ${DOWNLOAD_DIR} https://go.dev/dl/${GO_REV_RELEASE}.linux-amd64.tar.gz
	cd ${DOWNLOAD_DIR} ; tar -zxvf ${GO_REV_RELEASE}.linux-amd64.tar.gz
	cd ${DOWNLOAD_DIR} ; mv go ${GO_RELEASE}
