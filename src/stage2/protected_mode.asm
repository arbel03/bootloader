bits 16
protected_mode:
    cli
    lgdt [gdt_pointer]

    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    jmp gdt32.code:protected_mode_init

bits 32
protected_mode_init:
    mov ax, gdt32.data
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

	; qemu's default is 128 mb of ram
	mov ebp, 0x8FFFFFF
    mov esp, ebp
	
    call protected_mode_start

gdt32:
.null:
	dq 0x0
.code: equ $-gdt32
	; First flags- Preset(1), Privilege(00), Descriptor type(1)
	; Type flags- Code(1), Conforming(0), Readable(1), Accessed(0)
	; Second Flags- Granulatiry(1), 32-bit(1), 64-bit(0), AVL(0)
	dw 0xffff ;Limit (bits 0-15)
	dw 0x0 ;Base (bits 0-15)
	db 0x0 ;Base (bits 16-23)
	db 10011010b ;First flags, Type flags
	db 11001111b ;Second flags, Limit(bits 16-19)
	db 0x0 ;Base (bits 24-31)
.data: equ $-gdt32
	; Type flags- Code(0), Expand Down(0), Writeable(1), Accessed(0)
	dw 0xffff ;Limit (bits 0-15)
	dw 0x0 ;Base (bits 0-15)
	db 0x0 ;Base (bits 16-23)
	db 10010010b ;First flags, Type flags
	db 11001111b; Second flags, Limit(bits 16-19)
	db 0x0 ;Base (bits 24-31)
.end:

; gdt32:
; .null:
; 	dq 0x0
; .code: equ $-gdt32
; 	;First flags- Preset(1), Privilege(00), Descriptor type(1)
; 	;Type flags- Code(1), Conforming(0), Readable(1), Accessed(0)
; 	; flags- Granulatiry(1), 32-bit(1), 64-bit(0), AVL(0)
; 	dw 0xffff ;Limit (bits 0-15)
; 	dw 0x0 ;Base (bits 0-15)
; 	db 0b00100000 ;Base (bits 16-23)
; 	db 10011010b ;First flags, Type flags
; 	db 11001111b ;Second flags, Limit(bits 16-19)
; 	db 0x0 ;Base (bits 24-31)
; .data: equ $-gdt32
; ;Type flags- Code(0), Expand Down(0), Writeable(1), Accessed(0)
; 	dw 0xffff ;Limit (bits 0-15)
; 	dw 0x0 ;Base (bits 0-15)
; 	db 0b00100000 ;Base (bits 16-23)
; 	db 10010010b ;First flags, Type flags
; 	db 11001111b; Second flags, Limit(bits 16-19)
; 	db 0x0 ;Base (bits 24-31)
; .end:

gdt_pointer:
	dw gdt32.end - gdt32 -1 ;Size
	dd gdt32 ;Start address of the gdt 