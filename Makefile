bootloader ?= build/bootloader.bin
filesystem ?= build/filesystem.bin
os ?= build/os.bin

PHONY: clean all run

all: $(bootloader)

run: $(os) $(bootloader) $(filesystem)
	@qemu-system-i386 -drive file=$(os),format=raw

$(bootloader): 
	@mkdir -p build
	@nasm -f bin -o $@ src/bootloader.asm

$(filesystem):
	@mkfs.msdos -C $@ 20000
	@sudo mkdir -p /mnt
	@sudo mount -o loop $@ /mnt
	@sudo mkdir /mnt/boot
	@sudo umount /mnt

$(os): $(bootloader) $(filesystem)
	@cat $(bootloader) $(filesystem) > $@

clean:
	-@rm -r build