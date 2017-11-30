; al- ascii code
; This function prints a character represented by ascii
print_char:
    push ax
    mov ah, 0eh
    int 10h
    pop ax
    ret

; bx- pointer to string terminated by null byte
; This function prints a string
print_string:
    push bx
    push ax
.string_loop:
    mov al, byte [bx]
    or al, al
    jz end
    call print_char
    inc bx
    jmp .string_loop
end:
    pop ax
    pop bx
    ret

; al- decimal integer
; This function prints the input as a hex digit
print_hex_digit:
    push ax
    push bx

    xor ah, ah
    mov bx, hex
    add bx, ax
    mov al, byte [bx]
    call print_char

    pop bx
    pop ax
    ret

print_register:
    mov bx, 0xF000
    mov cx, 4
print_hex_loop:
    push ax

    and ax, bx

    push cx
    dec cx
    ; If cx is 0, we will enter an endless loop
    jz shift_done
    shift_ax_right:
        shr ax, 4
        loop shift_ax_right
shift_done:
    pop cx
    call print_hex_digit

    shr bx, 4
    pop ax
    loop print_hex_loop
ret
