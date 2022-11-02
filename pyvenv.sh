#!/usr/bin/env bash

OSID=`OSid`
if [ -z ${1+x} ]; then
    echo "Please supply venv directory name: venv.sh test001"
    exit 1
fi
VENV_NAME=$1
if [ -z ${2+x} ]; then
    PYTHON_REV=3.10.6
else
    PYTHON_REV=$2
fi
if [ -z ${3+x} ]; then
    VENV_DIR=~/.venv/${OSID}
else
    VENV_DIR=$3
fi
echo "VENV_NAME:  ${VENV_NAME}"
echo "PYTHON_REV: ${PYTHON_REV}"

VENV_ACTIVATE=${VENV_DIR}/${VENV_NAME}/bin/activate
mkdir -p ${VENV_DIR}
LOCAL_DIR="/projects/flow/tools/${OSID}/local"
if [ -z ${LD_LIBRARY_PATH+x} ]; then
    export _OLD_LD_LIBRARY_PATH=0
    export LD_LIBRARY_PATH="${LOCAL_DIR}/lib"
else
    export _OLD_LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
    export LD_LIBRARY_PATH="${LOCAL_DIR}/lib:${LD_LIBRARY_PATH}"
fi
/projects/flow/tools/${OSID}/python/v${PYTHON_REV}/bin/python3 -m venv ${VENV_DIR}/${VENV_NAME}
if [ -n "${_OLD_LD_LIBRARY_PATH:-}" ] ; then 
    if [ ${_OLD_LD_LIBRARY_PATH} = 0 ] ; then 
        unset LD_LIBRARY_PATH 
    else 
        export LD_LIBRARY_PATH=${_OLD_LD_LIBRARY_PATH} 
    fi 
    unset _OLD_LD_LIBRARY_PATH 
fi 
sed -i "s|deactivate () {|deactivate () {\
\n    if [ -n \"\${_OLD_LD_LIBRARY_PATH:-}\" ] ; then \
\n        if [ \${_OLD_LD_LIBRARY_PATH} = 0 ] ; then \
\n            unset LD_LIBRARY_PATH \
\n        else \
\n            export LD_LIBRARY_PATH=\${_OLD_LD_LIBRARY_PATH} \
\n        fi \
\n        unset _OLD_LD_LIBRARY_PATH \
\n    fi \
\n \
|g" ${VENV_ACTIVATE}
sed -i "s|deactivate nondestructive|deactivate nondestructive \
\n \
\nOSID=\`OSid\` \
\nLOCAL_DIR=\"/projects/flow/tools/\${OSID}/local\" \
\nif [ -z \${LD_LIBRARY_PATH+x} ]; then \
\n    export _OLD_LD_LIBRARY_PATH=0 \
\n    export LD_LIBRARY_PATH=\"\${LOCAL_DIR}/lib\" \
\nelse \
\n    export _OLD_LD_LIBRARY_PATH=\${LD_LIBRARY_PATH} \
\n    export LD_LIBRARY_PATH=\"\${LOCAL_DIR}/lib:\${LD_LIBRARY_PATH}\" \
\nfi \
|g" ${VENV_ACTIVATE}
echo  "source ${VENV_ACTIVATE}"
#source ${VENV_ACTIVATE}
