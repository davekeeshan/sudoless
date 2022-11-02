PROJECT       ?= apollo
PROJECT_VENV  ?= ${VENV_DIR}/${PROJECT}-${PYTHON_REV}
GIT_BASE_PATH ?= /projects/${PROJECT}/users/dkeeshan
REQUIREMENTS  ?= ${GIT_BASE_PATH}/${PROJECT}/requirements.txt

project_clean:
	rm -rf ${PROJECT_VENV}

project: | ${PROJECT_VENV}
	$(MAKE) project_update

${PROJECT_VENV}: python
	python3 -m venv ${PROJECT_VENV}

project_update:
	${PROJECT_VENV}/bin/pip install -U pip;
	if test -f "${REQUIREMENTS}"; then \
		${PROJECT_VENV}/bin/pip install -U -r ${REQUIREMENTS} ;\
	fi
