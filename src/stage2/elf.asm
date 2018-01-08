; IN: 
;       ebx- offset to ELF file in memory
bits 32
load_kernel:
    mov esi, [kernel_start+0x1C] ; program header offset
    mov ebx, esi
    add ebx, kernel_start

    mov ecx, [ebx+0x10] ; p_filesz- Size in bytes of the segment in the file image.
    mov edi, [ebx+0x08] ; p_vaddr- Virtual address of the segment in memory.
    mov esi, [ebx+0x04] ; p_offset- Offset of the segment in the file image.
    add esi, kernel_start

    cld
    rep movsb
    
    mov eax, [kernel_start+0x18] ; Entry point
    ret