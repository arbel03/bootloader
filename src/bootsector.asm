ORG 0x7c00

BITS 16
boot:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; Set stack, will be located at (0:0x7c00+0x7c00)
    mov sp, 0x7c00
    
    ; Setting CS using 
    jmp 0:.sec_cs 
.set_cs:
    
    jmp $

times 510 db 0
db 0x55
db 0xaa


