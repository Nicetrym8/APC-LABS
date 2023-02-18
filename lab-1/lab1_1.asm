
section .text
    global _start
    jmp _start
init_port:
    push bp
    mov bp, sp
    xor ax,ax
    mov dx, [bp+6]
    mov al, [bp+4]
    int 14h
    pop bp
    ret
write:
   push bp
   mov bp, sp
   mov dx,[bp+6]
   mov al, [bp+4]
   mov ah,1
   int 14h
   test ah,80h
   jnz write_error
   pop bp
   ret 
write_error:
   mov ah,09h
   mov dx, w_error_msg
   int 21h
   pop bp
   ret
read:
   push bp
   mov bp, sp
   mov dx,[bp+4]
   mov ah,2
   int 14h
   test ah,80h
   jnz read_error
   pop bp
   ret 
read_error:
   mov ah,09h
   mov dx, r_error_msg
   int 21h
   pop bp
   ret
    _start:

    mov si, data
	mov ds, si
	mov ax, stack
	mov ss, ax
	mov sp, stack_top

    push 0
    push 11100111b
    call init_port
    add sp,4

    push 0
    push "3"
    call write
    add sp,4  

    xor al, al
    push 0
    call read
    add sp,2

    mov dl, al
    mov ah, 02h
    int 21h
    
    mov ah, 4ch
	int 21h
section data
    w_error_msg db "Write error occured", 13,10,'$'
    r_error_msg db "Read error occured", 13,10,'$'
segment stack 
		resb 256
    
