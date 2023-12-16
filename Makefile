.PHONY: uf2
.PHONY: clean

ARM ?= arm-none-eabi
AS_ARGS = --warn --fatal-warnings -mcpu=cortex-m0
GCC_ARGS = -Wall -Werror -O2 -ffreestanding -mcpu=cortex-m0 -mthumb
LINK_ARGS = -nostdlib

all: clean bootrom.bin main.bin uf2
	@rm -f out/*.elf
	@rm -f out/*.o
	@rm -f out/*.bin


clean:
	@mkdir -p out
	@rm -rf out/*.*

# Build the uf2-util for generating uf2 compatible format
uf2:
	@uf2-util --bootrom out/bootrom.bin --progdata out/main.bin --output out/app.uf2

main.bin: src/main.c src/main.S
	$(ARM)-as $(AS_ARGS) src/main.S -o out/utils.o
	$(ARM)-gcc $(GCC_ARGS) -c src/main.c -o out/main.o
	$(ARM)-ld $(LINK_ARGS) -T src/linker.ld out/main.o out/utils.o -o out/main.elf
	@$(ARM)-objcopy -O binary out/main.elf out/main.bin
	@$(ARM)-objdump -D out/main.elf > out/main.asm

bootrom.bin: src/bootrom.c src/bootrom.S
	$(ARM)-as $(AS_ARGS) src/bootrom.S -o out/start.o
	$(ARM)-gcc $(GCC_ARGS) -c src/bootrom.c -o out/bootrom.o
	$(ARM)-ld $(LINK_ARGS) -T src/bootrom.ld out/start.o out/bootrom.o -o out/bootrom.elf
	@$(ARM)-objcopy -O binary out/bootrom.elf out/bootrom.bin
	@$(ARM)-objdump -D out/bootrom.elf > out/bootrom.asm

