#!/bin/env bash
MODULEFILE_DIR=${MODULEFILE_DIR:=''}
INSTALL_DIR=${INSTALL_DIR:='/cadtools'}
TOOL=${TOOL:=''}
REV=${REV:=''}
RELEASE=${RELEASE:=0}
LD_LIBRARY=${LD_LIBRARY:=0}
ADD_PATH=${ADD_PATH:=1}
ADD_MAN=${ADD_MAN:=0}
EXTRA_OPTS=${EXTRA_OPTS:=""}

if [ ! -d ${MODULEFILE_DIR} ] ; then
    echo "MODULEFILE_DIR ${MODULEFILE_DIR} not present"
fi

#Remove leading v if present
REVNOV=${REV#v}

COMMON_DIR=${MODULEFILE_DIR}/${TOOL}
mkdir -p ${COMMON_DIR}
COMMON_DIR=`readlink -f ${MODULEFILE_DIR}/${TOOL}`
#LINK_DIR=`readlink -f ${MODULEFILE_DIR}/${TOOL}`
#if [ ! -d ${LINK_DIR} ] ; then
#    ln -fs ${COMMON_DIR} ${LINK_DIR}
#fi

FILE=${COMMON_DIR}/.version
if [ ${RELEASE} == 1 ] || [ ! -f ${FILE} ]; then
    #echo $FILE
    echo -e "\
#%Module1.0\
\n##\
\nset ModulesVersion \"${REVNOV}\"\
" > ${FILE}
fi

FILE=${COMMON_DIR}/${REVNOV}
#echo ${FILE}
echo -e "\
#%Module###################################################################### \
\n##\
\nset INSTALL_DIR \"${INSTALL_DIR}\"\
\nset REV \"${REV}\"\
\nset TOOL \"${TOOL}\"\
\nset TOOL_DIR \"\${INSTALL_DIR}/\${TOOL}/\${REV}\"\
\n\
\nmodule unload \${TOOL}\
\n\
\nif { [file isdirectory \${TOOL_DIR}] } {\
" > ${FILE}
if [ ${ADD_PATH} == 1 ] ; then
    echo -e "\
    prepend-path     PATH            \${TOOL_DIR}/bin\
" >> ${FILE}
fi
if [ ${ADD_MAN} == 1 ] ; then
    echo -e "\
    prepend-path     MANPATH         \${TOOL_DIR}/man\
" >> ${FILE}
fi
if [ ${LD_LIBRARY} == 1 ] ; then
    echo -e "\
    prepend-path     LD_LIBRARY_PATH \${TOOL_DIR}/lib\
" >> ${FILE}
fi

if [ "${EXTRA_OPTS}" != "" ] ; then
    #echo "extra opts ${EXTRA_OPTS}"
    echo -e "${EXTRA_OPTS}" >> ${FILE}
fi
echo -e "\
}\
" >> ${FILE}
