.POSIX:
.PHONY: *
.ONESHELL:
.NOTPARALLEL:
.EXPORT_ALL_VARIABLES:

C_FILES := $(shell ls *.c)
ASM_FILES := $(shell ls *.asm)

SHELL := bash

build: build_asm build_c

build_c:
	$(foreach var,$(C_FILES),gcc -o $(shell echo ${var} | cut -f1 -d'.') ${var};)
build_asm:
	$(foreach var,$(ASM_FILES),nasm -f obj -o $(shell echo ${var} | cut -f1 -d'.').obj ${var};export SDL_VIDEODRIVER=dummy; dosbox -conf ../dosbox.conf -c "cd lab-1" -c "wlink file $(shell echo ${var} | cut -f1 -d'.').obj" -c exit;)
clean:
	$(foreach var,$(C_FILES),rm $(shell echo ${var} | cut -f1 -d'.');)
	rm *.obj *.EXE
	

