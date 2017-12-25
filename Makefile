$(iso): $(kernel)
	@nasm -f bin -o $(iso) -i bootloader/ bootloader/src/bootloader.asm