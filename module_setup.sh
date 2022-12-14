#!/usr/bin/bash
MODULEFILE_DIR=${MODULEFILE_DIR:=''}
TOOL=${TOOL:=''}
REV=${REV:=''}
RELEASE=${RELEASE:=0}
LD_LIBRARY=${LD_LIBRARY:=0}

#Remove leading v if present
REVNOV=${REV#v}

COMMON_DIR=${MODULEFILE_DIR}/common/${TOOL}
mkdir -p ${COMMON_DIR}
COMMON_DIR=`readlink -f ${MODULEFILE_DIR}/common/${TOOL}`
LINK_DIR=`readlink -f ${MODULEFILE_DIR}/${TOOL}`
if [ ! -d ${LINK_DIR} ] ; then
    ln -fs ${COMMON_DIR} ${LINK_DIR}
fi

FILE=${COMMON_DIR}/.version
if [ ${RELEASE} == 1 ] || [ ! -f ${FILE} ]; then
    #echo $FILE
    echo -e "\
#%Module1.0\
\n##\
\nset ModulesVersion \"${REV}\"\
" > ${FILE}
fi

FILE=${COMMON_DIR}/${REVNOV}
#echo ${FILE}
echo -e "\
#%Module###################################################################### \
\n##\
\nset rev \"${REV}\"\
\nset tool \"${TOOL}\"\
\nset os [exec /cadtools/osid]\
\nset toolpath "/cadtools/\${os}/common/\${tool}/\${rev}"\
\n\
\nif { [file isdirectory \${toolpath}] } {\
\n   prepend-path     PATH            \${toolpath}/bin\
\n   prepend-path     MANPATH         \${toolpath}/man\
" > ${FILE}
if [ ${LD_LIBRARY} == 1 ] ; then
    echo -e "\
   prepend-path     LD_LIBRARY_PATH \${toolpath}/lib\
" >> ${FILE}
fi
echo -e "\
}\
" >> ${FILE}
