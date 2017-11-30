assembly_source_file = src/bootsector.asm
bootloader = build/bootloader.bin

PHONY: all run clean

all: $(bootloader)

run: $(bootloader)
	@qemu-system-i386 -drive file=$(bootloader),format=raw

$(bootloader): $(assembly_source_file)
	@mkdir -p build
	@nasm -f bin -o $@ $<

clean:
	@rm -r build