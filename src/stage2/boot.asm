bits 16
startup:
    mov bx, my_string
    call print_string
    call print_line

    call load_kernel_to_memory

    call memory_map
    mov dword [info.mmap_addr], ebx
    mov dword [info.mmap_count], ecx

    call protected_mode

    hlt

load_kernel_to_memory:
    ; Loading kernel file to buffer bellow 1M
    ; Load kernel file to a temporary buffer
    mov ax, (kernel_start-stage1_start)/512
    mov bx, kernel_start
    mov cx, (kernel_end-kernel_start)/512
    xor dx, dx
    call load
    ret

; Entry address of protected mode code
bits 32
protected_mode_start:
    call load_kernel
    
    mov [info.kernel_start_address], ebx
    add ebx, ecx
    mov [info.kernel_end_address], ebx

    mov ebx, info
    call eax
    hlt

%include "src/stage2/elf.asm"
%include "src/stage2/protected_mode.asm"
%include "src/stage2/memory_map.asm"

info:
    .mmap_count: dd 0
    .mmap_addr: dd 0
    .kernel_start_address: dd 0
    .kernel_end_address: dd 0

a20_disabled_message: db 'A20 line is disabled.', 0
a20_enabled_message: db 'A20 line enabled.', 0
my_string: db 'Landed in stage2.', 0   