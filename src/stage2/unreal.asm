; Assembly example
 
bits 16
unreal:   
    cli                    ; no hardware interrupts

    push es
    push ds
    
    lgdt [ptr_unreal_gdt]         ; load gdt register

    mov eax, cr0           ; switch to pmode by
    or al,1                ; set pmode bit
    mov cr0, eax
    
    jmp $+2                ; tell 386/486 to not crash
    
    mov bx, unreal_gdt.data           ; select descriptor 1
    mov ds, bx             ; 8h = 1000b
    mov es, bx
    
    and al, 0xFE           ; back to realmode
    mov cr0, eax           ; by toggling bit again

    pop ds
    pop es
    sti
    ret

ptr_unreal_gdt:
    dw unreal_gdt.end - unreal_gdt - 1   ;last byte in table
    dd unreal_gdt                 ;start of table
 
unreal_gdt:
.null: dq 0         ; entry 0 is always unused
.data: equ $-unreal_gdt
	; Type flags- Code(0), Expand Down(0), Writeable(1), Accessed(0)
	dw 0xffff ;Limit (bits 0-15)
	dw 0x0 ;Base (bits 0-15)
	db 0x0 ;Base (bits 16-23)
	db 10010010b ;First flags, Type flags
	db 11001111b; Second flags, Limit(bits 16-19)
	db 0x0 ;Base (bits 24-31)
.end: