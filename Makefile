assembly_source_file = src/bootsector.asm
bootloader = build/bootloader.bin

all: $(bootloader) run

run: $(bootloader)
	qemu-system-i386 $(bootloader)

$(bootloader): $(assembly_source_file)
	mkdir -p build
	nasm -f bin -o $@ $<