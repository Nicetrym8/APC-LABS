.POSIX:
.PHONY: *
.ONESHELL:
.NOTPARALLEL:
.EXPORT_ALL_VARIABLES:

SHELL := bash
runargs := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
$(eval $(runargs):;@true)
run:
	dosbox -conf ../dosbox.conf -c "cd lab-2" -c $(runargs).com
build: 
	nasm $(runargs).asm -fbin -o $(runargs).com

	
	



