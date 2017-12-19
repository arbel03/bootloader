bits 32
; IN: 
;       ebx- offset to ELF file in memory
load_elf:
    mov ebx, kernel_start
    mov esi, [kernel_start+0x1C] ; program header offset
    mov ebx, esi

    mov ecx, [kernel_start+0x10+ebx] ; p_filesz- Size in bytes of the segment in the file image.
    mov edi, [kernel_start+0x08+ebx] ; p_vaddr- Virtual address of the segment in memory.
    mov esi, [kernel_start+0x04+ebx] ; p_offset- Offset of the segment in the file image.
    add esi, kernel_start

    rep movsb

    mov dword [0xb8000], 0x2f4b2f4f

    mov eax, [kernel_start+0x18] ; Entry point
    jmp eax

    ret

