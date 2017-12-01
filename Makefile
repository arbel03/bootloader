assembly_source_file ?= src/bootsector.asm
bootloader ?= build/bootloader.bin
filesystem ?= build/filesystem.bin # A file
os ?= build/iso/os.iso
# isofiles folder is defined by user

PHONY: clean all run

all: $(bootloader)

run: $(os) $(bootloader) $(filesystem)
	@qemu-system-i386 -drive file=$(bootloader),format=raw

$(bootloader): $(assembly_source_file)
	@mkdir -p build
	@nasm -f bin -o $@ $<

$(filesystem):
	# TODO: 
	# mkfs.fat
	# cat bootloader filesystem > os

$(os): $(bootloader) $(filesystem)
	cat $(bootloader) $(filesystem) > $@

clean:
	-@rm -r build