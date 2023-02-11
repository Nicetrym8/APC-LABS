.POSIX:
.PHONY: *
.ONESHELL:
.NOTPARALLEL:
.EXPORT_ALL_VARIABLES:

SHELL := bash
runargs := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
$(eval $(runargs):;@true)
run:
	make build $(runargs)
	dosbox -conf ../dosbox.conf -c "cd lab-1" -c $(runargs).exe -c 
build: 
	dosbox -conf ../dosbox.conf -c "cd lab-1" -c "wcl $(runargs).c" -c exit
	



