bits 16
startup:
    ; enable A20-Line via IO-Port 92, might not work on all motherboards
    in al, 0x92
    or al, 2
    out 0x92, al

    ; Printing stage 2 message
    mov bx, my_string
    call print_string
    call print_line

    ; Filling memory map
    call memory_map
    mov dword [info.mmap_addr], ebx
    mov dword [info.mmap_count], ecx

    mov eax, (kernel_start-stage1_start)/512 ; First sector of kernel
    mov edi, buffer_address ; Where to load kernel file to
    mov ecx, (kernel_end-kernel_start)/512 ; Size of kernel file in clusters
    call load_kernel_to_memory

    call protected_mode

    hlt

; Load part of disk to high memory
load_kernel_to_memory:
    buffer_size_sectors equ 127
.load_loop:
    cmp ecx, buffer_size_sectors
    jb .load_rest
    push eax
    push ecx
    push edi

    ; Load kernel file to a temporary buffer
    ; ax should hold the sector of the part to load
    ; bx should hold where to load that part to
    ; cx should be 127
    mov bx, stage2_end ; temporary buffer address
    mov ecx, buffer_size_sectors
    xor dx, dx
    call load

    ; Move that buffer to upper memory
    call unreal

    pop edi

    mov esi, stage2_end
    mov ecx, buffer_size_sectors * 512
    cld
    a32 rep movsb ; a32 to use fixed 32 bit addresses

    pop ecx
    pop eax

    add eax, buffer_size_sectors
    sub ecx, buffer_size_sectors

    jmp .load_loop
.load_rest:
    test ecx, ecx
    jz .finish ; if cx = 0 => skip

    push ecx
    push edi

    mov bx, stage2_end
    mov dx, 0x0
    call load

    ; moving remnants of kernel
    call unreal

    pop edi
    pop ecx

    mov esi, stage2_end
    shl ecx, 9 ; * 512
    cld
    a32 rep movsb

.finish:
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

%include "src/stage2/unreal.asm"
%include "src/stage2/memory_map.asm"
%include "src/stage2/protected_mode.asm"
%include "src/stage2/elf.asm"

info:
    .mmap_count: dd 0
    .mmap_addr: dd 0
    .kernel_start_address: dd 0
    .kernel_end_address: dd 0

buffer_address: equ 0x200000 ; Where to store kernel file temporary
my_string: db 'Landed in stage2.', 0