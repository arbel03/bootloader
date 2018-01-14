; IN: 
;       ebx- offset to ELF file in memory
bits 32
load_kernel:
    mov esi, [buffer_address+0x1C] ; program header offset
    mov ebx, esi
    add ebx, buffer_address

    mov ecx, [ebx+0x10] ; p_filesz- Size in bytes of the segment in the file image.
    mov edi, [ebx+0x08] ; p_vaddr- Virtual address of the segment in memory.
    mov esi, [ebx+0x04] ; p_offset- Offset of the segment in the file image.
    add esi, buffer_address

    cld
    rep movsb
    
    mov eax, [buffer_address+0x18] ; Entry point
    
    mov esi, [buffer_address+0x1C]
    add esi, buffer_address
    
    mov ebx, [esi+0x08] ; p_vaddr
    mov ecx, [esi+0x14] ; p_memsz- size of segment in memory
    ret