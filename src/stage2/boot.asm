bits 16

startup:
    mov bx, my_string
    call print_string
    call print_line

    call enable_a20
    call load_kernel

    call unreal
    call print_elf

    jmp $    

; ELF file is loaded to temporary buffer
print_elf:
    mov ax, word [kernel_start+0x2C]
    call print_register
    ret

load_kernel:
    ; Loading kernel file to buffer
    ; Load kernel file to a temporary buffer
    mov eax, (kernel_start-stage1_start)/512
    mov bx, kernel_start
    mov cx, (kernel_end-kernel_start)/512
    xor dx, dx
    call load
    ret

enable_a20:
    call check_a20
    cmp ax, 0 ; A20 is disabled
    jne .a20_enabled

    ; Print A20 is disabled
    mov bx, a20_disabled_message
    call print_string
    call print_line

    ; Enable A20 line
    in al, 0x92
    or al, 2
    out 0x92, al
.a20_enabled:
    ; Print A20 is enabled
    mov bx, a20_enabled_message
    call print_string
    call print_line
    ret


check_a20:
    pushf
    push ds
    push es
    push di
    push si
 
    cli
 
    xor ax, ax ; ax = 0
    mov es, ax
 
    not ax ; ax = 0xFFFF
    mov ds, ax
 
    mov di, 0x0500
    mov si, 0x0510
 
    mov al, byte [es:di]
    push ax
 
    mov al, byte [ds:si]
    push ax
 
    mov byte [es:di], 0x00
    mov byte [ds:si], 0xFF
 
    cmp byte [es:di], 0xFF
 
    pop ax
    mov byte [ds:si], al
 
    pop ax
    mov byte [es:di], al
 
    mov ax, 0
    je .check_a20__exit
 
    mov ax, 1
 .check_a20__exit:
    pop si
    pop di
    pop es
    pop ds
    popf
 
    ret

%include "src/stage2/unreal.asm"
%include "src/stage2/elf.asm"

a20_disabled_message: db 'A20 line is disabled.', 0
a20_enabled_message: db 'A20 line enabled.', 0
my_string: db 'Landed in stage2.', 0