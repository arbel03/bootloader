[bits 32]
; Define consts
VIDEO_MEMORY equ 0xB8000
WHITE_ON_BLACK equ 0x0f


print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY

print_string_pm_loop:
	mov al, [ebx] ; store char in al
	mov ah, WHITE_ON_BLACK ; store attrib in ah
	
	cmp al, 0 ; if al==0
	je print_string_pm_done ; jmp to done
	
	mov [edx], ax ; Stores char and attrib in current chars cell.
	add ebx, 1 ; inc ebx
	add edx, 2 ; mov to next cell in vid mem
	
	jmp print_string_pm_loop

print_string_pm_done:
	popa
	ret

	