stage1_source_files ?= $(wildcard src/stage1/*.asm)
stage1_object_files ?= $(patsubst src/stage1/%.asm, build/stage1/%.o, $(stage1_source_files))
bootloader ?= build/bootloader.bin
os ?= build/os.bin

PHONY: clean all run

all: $(bootloader)

$(bootloader):
	-@mkdir -p build
	@nasm -f bin -o $@ -i src src/bootloader.asm 

run: $(bootloader) 
	@qemu-system-i386 -drive file=$(bootloader),format=raw

clean:
	-@rm -r build