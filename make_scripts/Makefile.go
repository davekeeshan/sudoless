GO_REPO       := https://go.googlesource.com/go
GO_REV        ?= go1.19.1
GO_INSTALL    := ${INSTALL_DIR}/go/${GO_REV}
GO_DIR        := ${DOWNLOAD_DIR}/go-git

go_clean:
	rm -rf ${GO_INSTALL}

go: mkdir_install gcc make | ${GO_INSTALL}

${GO_DIR}: 
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
		export PATH=/projects/flow/tools/compile/${GO_REV}/bin:${PATH}; \
		./all.bash; \
		mkdir -p ${GO_INSTALL}; \
		cp -r ../bin ${GO_INSTALL}/bin
	$(MAKE) go_link

go_link:
	ln -fs $(shell ls ${GO_INSTALL}/bin/*) ${INSTALL_DIR}/local/bin/.

go_release:
	rm -rf ${GO_REV}
	wget -c https://go.dev/dl/${GO_REV}.linux-amd64.tar.gz
	tar -zxvf ${GO_REV}.linux-amd64.tar.gz
	mv go ${GO_REV}
	#mv go ${GO_DIR}
