section .text
    global _start
    jmp _start
init_port:
    mov dx, 3fbh
    mov al,10000111b
    out dx,al
    sub dx,3
    mov al, 0x0c
    out dx,al
    add dx,1
    xor al,al
    out dx,al
    and al, 111b
    add dx,2
    out dx,al
    ret
write:
   push bp
   mov bp, sp
   mov al, [bp+4]
   mov dx,3F8h
   out dx,al
   mov dx,3FDh
   in al,dx
   test al,10h
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
   mov dx,3F8h
   in al,dx
   pop bx
   push ax
   push bx
   mov dx,3FDh
   in al,dx
   test al,10h
   jnz read_error
   ret 
read_error:
   mov ah,09h
   mov dx, r_error_msg
   int 21h
   ret
    _start:

    mov si, data
	mov ds, si
	mov ax, stack
	mov ss, ax
	mov sp, stack_top

    call init_port

    push "8"
    call write
    add sp,2 

    call read
    pop dx
    mov ah, 02h
    int 21h
    
    mov ah, 4ch 
	int 21h
section data
    w_error_msg db "Write error occured", 13,10,'$'
    r_error_msg db "Read error occured", 13,10,'$'
segment stack 
		resb 256
	stack_top: