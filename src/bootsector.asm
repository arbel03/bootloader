ORG 0x7c00

BITS 16
start:

BPB:
    

    ; Set stack, will be located at (0:0x7c00+0x7c00)
    mov sp, 0x7c00

    ; Storing disk number
    mov [disk_number], dl

    mov bx, disk_number_message
    call print_string

    mov ax, dx
    xor ah, ah
    call print_register

    jmp $

%include "src/print.asm"

hex db '0123456789abcdef'
disk_number_message db 'Disk number: ',0
disk_number db 0

times 510-($-$$) db 0
dw 0xaa55

times 512 db 'xa'

