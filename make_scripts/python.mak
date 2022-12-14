# make python PYTHON_REV=v3.10.4
CWD               ?= ${PWD}
PYTHON_REV        ?= v3.10.7
PYTHON_NAME       := python
PYTHON_INSTALL    := ${INSTALL_DIR}/${PYTHON_NAME}/${PYTHON_REV}
PYTHON_DIR        := ${DOWNLOAD_DIR}/cpython-git
#PYTHON_REPO       := https://github.com/python/cpython.git
PYTHON_REPO       := git@github.com:python/cpython.git
PYTHON_RELEASE    := 0
VENV_PATH         := ${CWD}/.venv_python/${OSID}
SYSTEM_PYTHON     ?= 1

ifeq ($(SYSTEM_PYTHON), 0)
	PATH := ${PYTHON_INSTALL}/bin:${PATH}
	LD_LIBRARY_PATH := ${PYTHON_INSTALL}/lib:${LD_LIBRARY_PATH}
# else
# 	LD_LIBRARY_PATH := /projects/flow/tools/x86_64-rocky8/python/v3.10.7/lib:${LD_LIBRARY_PATH}
# 	#LD_LIBRARY_PATH := $(shell which python)/../../lib:${LD_LIBRARY_PATH}
endif

pydeactivate:
	rm -rf ${VENV_PATH}

pyactivate: | python
	@$(MAKE) pydeactivate
	export LD_LIBRARY_PATH=${PYTHON_INSTALL}/lib;\
	${PYTHON_INSTALL}/bin/python3 -m venv ${VENV_PATH};\
	export PATH=${VENV_PATH}/bin:${PATH} ; \
	pip install -U pip 

python_clean:
	rm -rf ${PYTHON_INSTALL}

python: mkdir_install | ${PYTHON_INSTALL}
ifeq (${SYSTEM_PYTHON}, 0)
	@echo "Make sure you set:"
	@echo "    export LD_LIBRARY_PATH=${PYTHON_INSTALL}/lib"
# 	@echo "OR"
# 	@echo "    export LD_LIBRARY_PATH=${INSTALL_DIR}/local/lib"
endif

python_dependancy: gcc make libffi openssl tcl tk sqlite bzip2 xy


${PYTHON_DIR}:
ifeq (${SYSTEM_PYTHON}, 0)
	@echo "Folder ${PYTHON_DIR} does not exist"
	git clone ${PYTHON_REPO} $(PYTHON_DIR)
endif

${PYTHON_INSTALL}:| ${PYTHON_DIR}
ifeq (${SYSTEM_PYTHON}, 0)
	$(MAKE) python_dependancy
	if [ "${PYTHON_REV}" = "" ]; then \
		cd ${PYTHON_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${PYTHON_DIR}; \
			git fetch; \
        	git checkout -f ${PYTHON_REV};\
    fi
	cd ${PYTHON_DIR}; \
		export CFLAGS="-I${BZIP2_INSTALL}/include -I${XY_INSTALL}/include -I${NCURSES_INSTALL}/usr/include"; \
		export LDFLAGS="-Wl,-rpath=${OPENSSL_INSTALL}/lib,-rpath=${LIBFFI_INSTALL}/lib64,-rpath=${SQLITE_INSTALL}/lib,-rpath=${BZIP2_INSTALL}/lib,-rpath=${XY_INSTALL}/lib,-rpath=${TCL_INSTALL}/lib,-rpath=${TK_INSTALL}/lib,-rpath=${NCURSES_INSTALL}/usr/lib -L${LIBFFI_INSTALL}/lib64 -L${BZIP2_INSTALL}/lib -L${XY_INSTALL}/lib -L${NCURSES_INSTALL}/usr/lib"; \
		export PKG_CONFIG_PATH="${LIBFFI_INSTALL}/lib/pkgconfig:${XY_INSTALL}/lib/pkgconfig"; \
		rm -rf build; mkdir build; \
		make clean; \
		sed -i "s|'\/usr\/local\/include\/sqlite3',|'\/usr\/local\/include\/sqlite3',\n                             '${SQLITE_INSTALL}\/include',|g" setup.py; \
        ./configure \
			--with-ensurepip=install \
			--enable-shared \
			--prefix=${PYTHON_INSTALL} \
			--with-openssl=${OPENSSL_INSTALL} \
			--with-tcltk-includes='-I${TCL_INSTALL}/include -I${TK_INSTALL}/include' \
			--with-tcltk-libs='-L${TCL_INSTALL}/lib -L${TK_INSTALL}/lib -ltcl8.6 -ltk8.6' \
            --enable-optimizations \
            --with-computed-gotos=yes \
            --with-dbmliborder=gdbm:ndbm:bdb \
            --enable-loadable-sqlite-extensions \
			--without-static-libpython ; \
        make -j ${PROCESSOR} ;\
		make install
	ln -fs ${PYTHON_INSTALL}/bin/python3 ${PYTHON_INSTALL}/bin/python
#	$(MAKE) python_link
	$(MAKE) python_module
else
	@echo "Using System python"
endif

python_module: ${PYTHON_INSTALL}
	@export MODULEFILE_DIR=${MODULEFILE_DIR};\
	export TOOL=${PYTHON_NAME};\
	export REV=${PYTHON_REV};\
	export LD_LIBRARY=1;\
	export RELEASE=${PYTHON_RELEASE};\
		./module_setup.sh

python_link:
	ln -fs $(shell ls ${PYTHON_INSTALL}/lib/libpython3.*.so*) ${INSTALL_DIR}/local/lib/.

# 		export PATH=$(GCC_INSTALL)/bin:$(MAKE_INSTALL)/bin:${PATH}; \
#    --with(out)-readline[=editline]
#   --without-static-libpython
# --with-libs=/projects/flow/tools/x86_64-centos7/sqlite/3.39.1/lib
#   --with-libs='lib1 ...'  link against additional libs (default is no)
#             --with-readline \
#            --with-dtrace \
#             --with-system-expat \
#        make -j ${PROCESSOR} > temp.txt;\

pyuser:
	mkdir -p ${HOME}/.venv
	${PYTHON_INSTALL}/bin/python3 -m venv ${HOME}/.venv/Python-${PYTHON_REV}
	@sed -i "s|deactivate () {|deactivate () {\
\n    if [ -n \"\$${_OLD_LD_LIBRARY_PATH:-}\" ] ; then\
\n        if [ \$${_OLD_LD_LIBRARY_PATH} = 0 ] ; then \
\n            unset LD_LIBRARY_PATH \
\n        else \
\n            export LD_LIBRARY_PATH=\$${_OLD_LD_LIBRARY_PATH} \
\n        fi \
\n        unset _OLD_LD_LIBRARY_PATH \
\n    fi \
\n \
|g" ${HOME}/.venv/Python-${PYTHON_REV}/bin/activate

	@sed -i "s|deactivate nondestructive|deactivate nondestructive \
\n \
\nLOCAL_DIR=\"${PYTHON_INSTALL}\" \
\nif [ -z \$${LD_LIBRARY_PATH+x} ]; then \
\n    export _OLD_LD_LIBRARY_PATH=0 \
\n    export LD_LIBRARY_PATH=\"\$${LOCAL_DIR}/lib\" \
\nelse \
\n    export _OLD_LD_LIBRARY_PATH=\$${LD_LIBRARY_PATH} \
\n    export LD_LIBRARY_PATH=\"\$${LOCAL_DIR}/lib:\$${LD_LIBRARY_PATH}\" \
\nfi \
|g" ${HOME}/.venv/Python-${PYTHON_REV}/bin/activate
