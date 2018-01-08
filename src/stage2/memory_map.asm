; Taken from here https://github.com/redox-os/bootloader/blob/master/x86_64/memory_map.asm

bits 16
memory_map:
.start  equ 0x0500
.end    equ 0x5000

    mov di, .start
    mov edx, 0x534D4150
    xor ebx, ebx
    xor esi, esi
.lp:
    inc esi
    mov eax, 0xE820
    mov ecx, 24

    int 0x15
    jc .done ; Error or finished

    cmp ebx, 0
    je .done ; Finished

    add di, 24
    cmp di, .end
    jb .lp ; Still have buffer space
.done:
    mov ecx, esi
    mov ebx, .start
    ret