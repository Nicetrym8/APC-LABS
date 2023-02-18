
bits 16
org 100h
start:
        jmp init 
        align 4 
int_old:
        times 16 dd 0
int8_handler:
        call basic_handler
        jmp far [cs:int_old]
int9_handler:
        call basic_handler
        jmp far [cs:int_old+4]
intA_handler:
        call basic_handler
        jmp far [cs:int_old+8]
intB_handler:
        call basic_handler
        jmp far [cs:int_old+12]
intC_handler:
        call basic_handler
        jmp far [cs:int_old+16]
intD_handler:
        call basic_handler
        jmp far [cs:int_old+20]
intE_handler:
        call basic_handler
        jmp far [cs:int_old+24]
intF_handler:
        call basic_handler
        jmp far [cs:int_old+28]
int70_handler:
        call basic_handler
        jmp far [cs:int_old+32]
int71_handler:
        call basic_handler
        jmp far [cs:int_old+36]
int72_handler:
        call basic_handler
        jmp far [cs:int_old+40]
int73_handler:
        call basic_handler
        jmp far [cs:int_old+44]
int74_handler:
        call basic_handler
        jmp far [cs:int_old+48]
int75_handler:
        call basic_handler
        jmp far [cs:int_old+52]
int76_handler:
        call basic_handler
        jmp far [cs:int_old+56]
int77_handler:
        call basic_handler
        jmp far [cs:int_old+60]



;ax - val
;bx - offset
print:
        mov si,0B800h
        mov es,si
        mov si, bx
        shl si,1
        mov cx,8
        mov dl,(1<<7)
print_loop:
        test al,dl
        je zero
        mov word[es:si],(0x4300 +'1')
        jmp end_print
zero:
        mov word[es:si],(0x4300+'0')
end_print:
        add si,2
        shr dl,1
        loop print_loop
        ret
basic_handler:
        cli
        in ax,20h;  get mask Master
        xor bx,bx
        call print

        add bx,15
        in ax,0xA0; get mask Slave
        call print

        add bx,65
        mov al,0ah                                   
        out 20h,al; get request register Master
	in al,20h
        call print
        
        add bx,15
        mov al,0ah                                   
        out 0xA0,al; get request register Master
	in al,0xA0
        call print

        add bx,65
        mov al,0bh                                   
        out 20h,al; get service register Master
	in al,20h
        call print

        add bx,15
        mov al,0bh                                   
        out 0xA0,al; get service register Slave
	in al,0xA0
        call print

      
        sti
        ret       
end_of_resident:
init: 
       xor di,di
       mov al,08h
       call get_old_handlers
       mov al,70h
       call get_old_handlers
        

       mov ax, 2508h
       mov dx, int8_handler
       int 21h

       add ax,1
       mov dx, int9_handler
       int 21h

       add ax,1
       mov dx, intA_handler
       int 21h

       add ax,1
       mov dx, intB_handler
       int 21h

       add ax,1
       mov dx, intC_handler
       int 21h

       add ax,1
       mov dx, intD_handler
       int 21h

       add ax,1
       mov dx, intE_handler
       int 21h

       add ax,1
       mov dx, intF_handler
       int 21h

       mov ax,25A8h
       mov dx, int70_handler
       int 21h

       add ax,1
       mov dx, int71_handler
       int 21h

       add ax,1
       mov dx, int72_handler
       int 21h

       add ax,1
       mov dx, int73_handler
       int 21h

       add ax,1
       mov dx, int74_handler
       int 21h

       add ax,1
       mov dx, int75_handler
       int 21h

       add ax,1
       mov dx, int76_handler
       int 21h

       add ax,1
       mov dx, int77_handler
       int 21h

        cli
        
       mov al,11h ;ICW1 - initialize Master
       out 20h,al
       mov al,08h ;ICW2 - base vector for master
       out 21h,al
       mov al,04h ;ICW3 - the port bit of Slave (in binary format)
       out 21h,al  
       mov al,1h ;ICW4 - default
       out 21h,al 

        mov al,11h ;ICW1 - initialize Slave
        out 0xA0,al
        mov al,0xA8 ;ICW2 - base vector for slave
        out 0xA1,al
        mov al,2h ;ICW3 - the port number of connected port on Master 
        out 0xA1,al 
        mov al,1h ;ICW4 - default
        out 0xA1,al 
        sti

        mov ax, 3100h
        mov dx, (end_of_resident - start + 10fh) >> 4
        int 21h
get_old_handlers:
        mov cx, 8
        mov ah, 35h
get_loop:
        
        int 21h
        mov word [cs:int_old + 2+di], es
        mov word [cs:int_old+di], bx  
        add di,4
        add al,1
        loop get_loop
        ret