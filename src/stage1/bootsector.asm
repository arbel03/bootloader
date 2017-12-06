bits 16

start:    
    ; Setting code segment
    jmp 0x07c0:.init_cs
.init_cs:
    mov ax, cs
    mov ds, ax
    mov fs, ax
    mov gs, ax

    ; Set a temporary stack, will be located at (0:0x7c00)
    xor ax, ax
    mov ss, ax
    mov sp, 0x7c00

    ; Storing disk number
    mov [disk_number], dl

    call load
    jmp stage2

    jmp $

disk_error:
    mov bx, disk_error_message
    call print_string
    shr ax, 8
    call print_register
    call print_line
    jmp $

load:
    ; Calculating sectors to load
    mov dx, 0
    mov ax, stage2_end - stage2
    mov bx, 512 ; Divide by 512, sector size
    div bx ; AX (Quotient), DX (Remainder)

    mov dh, al ; Moving sectors to read to dh
    mov dl, [disk_number] ; Moving disk number to dl
    mov bx, stage2
    mov ax, cs
    mov es, ax
    call disk_load
    jc disk_error

    mov bx, disk_load_message
    call print_string
    xor ah, ah
    call print_register ; Printing amount of sectors loaded to memory, stored in al
    call print_line
    ret

%include "src/stage1/print.asm"
%include "src/stage1/disk_load.asm"

hex db '0123456789abcdef'
disk_error_message db 'Disk error! error code: ', 0
disk_load_message db 'Loaded sectors: ', 0
disk_number db 0

times 510-($-$$) db 0
dw 0xaa55