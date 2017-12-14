bits 16

stage2_start:
    mov bx, my_string
    call print_string
    jmp $

my_string: db 'Landed in stage2.', 0