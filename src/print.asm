print_string:
    push ax
    push bx
    mov ah, 0eh
.print_char:
    mov al, byte [bx]
    or al, al
    jz end
    int 10h
    inc bx
    jmp .print_char
end:
    pop bx
    pop ax
    ret

