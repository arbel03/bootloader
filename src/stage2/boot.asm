bits 16

stage2_start:
    mov bx, my_string
    call print_string
    jmp $

my_string: times 500 db 'x' 
db 0