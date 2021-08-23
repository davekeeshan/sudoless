TMUX_REPO     := https://github.com/tmux/tmux.git
TMUX_REV      ?= 3.3a 
TMUX_INSTALL  := ${INSTALL_DIR}/tmux/${TMUX_REV}
TMUX_DIR      := ${DOWNLOAD_DIR}/tmux-git

tmux_clean:
	rm -rf ${TMUX_INSTALL}

tmux: mkdir_install gcc libevent | $(TMUX_INSTALL)

${TMUX_DIR}: 
	@echo "Folder ${TMUX_DIR} does not exist"
	git clone ${TMUX_REPO} ${TMUX_DIR}

${TMUX_INSTALL}: | ${TMUX_DIR}
	@echo "Folder $(TMUX_INSTALL) does not exist"
	if [ "${TMUX_REV}" = "" ]; then \
		cd ${TMUX_DIR}; \
			git fetch; \
        	git checkout -f master;\
	else \
		cd ${TMUX_DIR}; \
			git fetch; \
        	git checkout -f ${TMUX_REV};\
    fi
	cd ${TMUX_DIR}; \
		export LIBEVENT_CFLAGS="-I${LIBEVENT_INSTALL}/include"; \
		export LIBEVENT_LIBS="-L${LIBEVENT_INSTALL}/lib"; \
		./autogen.sh; \
		./configure --prefix=$(TMUX_INSTALL); \
		make clean; \
		make; \
# 		make install        
     
# #   - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
# #      during execution
# #    - add LIBDIR to the `LD_RUN_PATH' environment variable
# #      during linking
# #    - use the `-Wl,-rpath -Wl,LIBDIR' linker flag
# # 		export LD_RUN_PATH="${LIBEVENT_INSTALL}/lib"; \
# #   LIBEVENT_CFLAGS
# #               C compiler flags for LIBEVENT, overriding pkg-config
# #   LIBEVENT_LIBS
# #               linker flags for LIBEVENT, overriding pkg-config
# 		export LD_LIBRARY_PATH="$(GCC_INSTALL)/lib64:${LIBEVENT_INSTALL}/lib:${NCURSES_INSTALL}/usr/lib"; \
# 		export LD_RUN_PATH="$(GCC_INSTALL)/lib64:${LIBEVENT_INSTALL}/lib:${NCURSES_INSTALL}/usr/lib"; \
# 		export LIBNCURSES_CFLAGS="-I${NCURSES_INSTALL}/usr/include"; \
# 		export LIBNCURSES_LIBS="-L${NCURSES_INSTALL}/usr/lib"; \
# 		export LDFLAGS="-Wl,-rpath=${LIBEVENT_INSTALL}/lib,-rpath=${NCURSES_INSTALL}/lib -L${LIBEVENT_INSTALL}/lib -L${NCURSES_INSTALL}/usr/lib"; \
