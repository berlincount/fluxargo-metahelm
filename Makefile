SHELL=/bin/bash
.PHONY: tests

tests: tests/*-expected.yaml
	for TESTFILE in $^ ; do \
	  TESTFILE=$${TESTFILE} ; \
	  FILENAME=$$(basename $$TESTFILE) ; \
	  RELEASENAME=$${FILENAME/-expected.yaml/} ; \
	  VALUESFILE=$${FILENAME/-expected/-values} ; \
	  set -ex ; \
	  helm template $${RELEASENAME} . -f tests/$${VALUESFILE} | diff -u - $${TESTFILE} ; \
	done
