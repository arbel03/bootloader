stage1:
    %include "bootloader/src/stage1/bootsector.asm"
stage1_end:

stage2:
    %include "bootloader/src/stage2/boot.asm"
    align 512, db 0
stage2_end:

kernel:
    incbin "build/kernel.bin"
    align 512, db 0
kernel_end:

; %incbin filesystem.bin, 512; include the whole filesystem file containing the kernel and skip the first 512 bytes, the mbr...