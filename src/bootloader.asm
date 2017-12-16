stage1_start:
    %include "src/stage1/bootsector.asm"
stage1_end:

stage2_start:
    %include "src/stage2/boot.asm"
    align 512, db 0
stage2_end:

kernel_start:
    incbin "../build/kernel.bin"
    align 512, db 0
kernel_end:

; incbin "../build/filesystem.bin", 512 ; include the whole filesystem file containing the kernel and skip the first 512 bytes, the mbr...