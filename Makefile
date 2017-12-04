stage1_source_files ?= $(wildcard src/stage1/*.asm)
stage1_object_files ?= $(patsubst src/stage1/%.asm, build/stage1/%.o, $(stage1_source_files))
bootloader ?= build/bootloader.bin
filesystem ?= build/filesystem.bin
os ?= build/os.bin

PHONY: clean all run

all: $(bootloader)

$(bootloader): $(stage1_object_files)
	@ld -n -m elf_i386 --oformat binary -T linker.ld -o $@ $(stage1_object_files)

run: $(bootloader) 
	@qemu-system-i386 -drive file=$(bootloader),format=raw

build/stage1/%.o: src/stage1/%.asm
	@mkdir -p build/stage1
	@nasm -f elf32 -o $@ $<

clean:
	-@rm -r build