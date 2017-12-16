bits 16

unreal:
    cli ; No interrupts
    push ds
    lgdt [unreal_gdtr]

    mov  eax, cr0          ; switch to pmode by
    or al,1                ; set pmode bit
    mov  cr0, eax

    jmp $+2 ; Align 
    
    mov  bx, 0x08          ; select descriptor 1
    mov  ds, bx            ; 8h = 1000b

    and al,0xFE            ; back to realmode
    mov  cr0, eax          ; by toggling bit again

    pop ds
    sti
    ret

unreal_gdtr:
   dw unreal_gdt.end - unreal_gdt - 1   ;last byte in table
   dd unreal_gdt                 ;start of table
 
unreal_gdt:
.null: equ $ - unreal_gdt 
    dq 0 ; entry 0 is always unused
.data: equ $ - unreal_gdt
    db 0xff, 0xff, 0, 0, 0, 10010010b, 11001111b, 0 ; Flat descriptor, starting from ff
.end: