bits 16
startup:
    mov bx, my_string
    call print_string
    call print_line

    call load_kernel_to_memory

    call protected_mode

    hlt

load_kernel_to_memory:
    ; Loading kernel file to buffer
    ; Load kernel file to a temporary buffer
    mov ax, (kernel_start-stage1_start)/512
    mov bx, kernel_start
    mov cx, (kernel_end-kernel_start)/512
    xor dx, dx
    call load
    ret

bits 32
protected_mode_start:
    mov ebx, kernel_start
    call load_elf
    hlt

%include "src/stage2/unreal.asm"
%include "src/stage2/elf.asm"
%include "src/stage2/protected_mode.asm"

a20_disabled_message: db 'A20 line is disabled.', 0
a20_enabled_message: db 'A20 line enabled.', 0
my_string: db 'Landed in stage2.', 0   