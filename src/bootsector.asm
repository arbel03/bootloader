ORG 0x7c00

BITS 16
start:
    ; Set stack, will be located at (0:0x7c00+0x7c00)
    mov sp, 0x7c00
    
    mov bx, hello
    call print_string

    jmp $

%include "src/print.asm"

hello db 'The quick brown fox jumps over the lazy dog!',0

times 510-($-$$) db 0
dw 0xaa55

times 512 db 'x','a'

