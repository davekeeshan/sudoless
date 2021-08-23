CWD            ?= ${PWD}
SCRIPTS_DIR    ?= ${CWD}/make_scripts
SYSTEM_GCC     ?= 1
SYSTEM_MAKE    ?= 1
SYSTEM_GIT     ?= 1
SYSTEM_BASH    ?= 1
SYSTEM_CURL    ?= 1
SYSTEM_PERL    ?= 1
SYSTEM_PYTHON  ?= 1

include ${SCRIPTS_DIR}/Makefile
