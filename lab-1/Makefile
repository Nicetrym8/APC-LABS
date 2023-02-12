.POSIX:
.PHONY: *
.ONESHELL:
.NOTPARALLEL:
.EXPORT_ALL_VARIABLES:

SHELL := bash
runargs := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
$(eval $(runargs):;@true)
prepare:
	sudo modprobe tty0tty
	sudo chmod 666 /dev/tnt*
run:
	dosbox -conf ../dosbox.conf -c "cd lab-1" -c $(runargs).exe
build: 
	dosbox -conf ../dosbox.conf -c "cd lab-1" -c "wcl $(runargs).c" -c exit
build_asm:
	nasm $(runargs).asm -o $(runargs).obj -f obj
	make link_asm $(runargs)
link_asm: 
	dosbox -conf ../dosbox.conf -c "cd lab-1" -c "wlink file $(runargs).obj" -c exit
build_linux:
	gcc $(runargs).c -o $(runargs).o
	
	



