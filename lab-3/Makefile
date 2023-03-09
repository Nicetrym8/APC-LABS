.POSIX:
.PHONY: *
.ONESHELL:
.NOTPARALLEL:
.EXPORT_ALL_VARIABLES:

SHELL := bash
runargs := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
$(eval $(runargs):;@true)
run:
	dosbox -conf ../dosbox.conf -c "cd lab-3" -c $(runargs).exe
build: 
	dosbox -conf ../dosbox.conf -c "cd lab-3" -c "wcl $(runargs).c"

	
	



