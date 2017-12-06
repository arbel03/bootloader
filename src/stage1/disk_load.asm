disk_load:
    push dx
    
    mov ah, 0x02
    mov al, dh ; Amount of sectors
    mov ch, 0x00 ; Cylinder 0
    mov dh, 0x00 ; Head 0
    mov cl, 0x02 ; Reading from second sector

    int 0x13

    ; al will hold the amount of sectors read 
    pop dx
    ret