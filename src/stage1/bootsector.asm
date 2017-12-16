org 0x7c00
bits 16

boot:    
    xor ax, ax
    mov ds, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Setting code segment
    jmp 0x0:.init_cs
.init_cs:

    ; Set a temporary stack, will be located at (0:0x7c00)
    mov sp, 0x7c00

    ; Storing disk number
    mov [disk], dl

    ; Loading stage 2
    mov eax, (stage2_start-stage1_start)/512
    mov bx, stage2_start
    mov cx, (stage2_end-stage2_start)/512
    xor dx, dx
    call load

    mov bx, stage1_message
    call print_string
    call print_line

    jmp startup

    jmp $

disk_error:
    mov bx, disk_error_message
    call print_string
    shr ax, 8
    call print_register
    call print_line
    jmp $

; ax: start sector
; bx: offset of buffer
; cx: number of sectors to read(512 bytes)
; dx: segment of buffer
load:
    cmp cx, 127
    jbe .good_size

    pusha
    mov cx, 127
    call load
    popa
    add eax, 127
    add dx, 127 * 512 / 16
    sub cx, 127

    jmp load
.good_size:
    mov [DAPACK.address], eax ; 32bit value is needed, higher bits of eax will be zeros
    mov [DAPACK.sectors_to_load], cx
    mov [DAPACK.segment], dx
    mov [DAPACK.offset], bx

    mov dl, [disk]
    mov si, DAPACK
    mov ah, 0x42
    int 0x13
    jc disk_error
    ret

%include "src/stage1/print.asm"

hex db '0123456789abcdef'
disk_error_message db 'Disk error! error code: ', 0
stage1_message db 'Stage 1 - Finished', 0
disk db 0

DAPACK:
    db 0x10
    db 0
.sectors_to_load: ; Number of sectors to load, max is 127 on most bioses
    dw 127 
.offset: ; Where to load the values
    dw 0x0
.segment: 
    dw 0x0
.address: ; Where to read from
    dq 0x0

times 510-($-$$) db 0
dw 0xaa55