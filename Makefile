SHELL=/bin/bash
.PHONY: tests

tests: tests/*-expected.yaml
	for TESTFILE in $^ ; do \
	  TESTFILE=$${TESTFILE} ; \
	  FILENAME=$$(basename $$TESTFILE) ; \
	  RELEASENAME=$${FILENAME/-expected.yaml/} ; \
	  VALUESFILE=$${FILENAME/-expected/-values} ; \
	  set -x ; \
	  helm template $${RELEASENAME} . -f tests/$${VALUESFILE} | diff -u10 - $${TESTFILE} ; \
	  A=$${PIPESTATUS[0]} B=$${PIPESTATUS[1]} ; \
	  set +x ; \
	  if [ $$A -eq 1 ] && [ "$$TESTFILE" == "tests/empty-expected.yaml" ]; then \
	    echo Failure for \"$$TESTFILE\" ok. ; \
	  elif [ $$A -eq 0 ] && [ $$B -eq 0 ] && [ "$$TESTFILE" != "tests/empty-expected.yaml" ]; then \
	    echo Example \"$$TESTFILE\" ok. ; \
	  else \
	    echo Unexpected result. ; \
	    exit 1 ; \
	  fi ; \
	done

lint:
	helm lint
