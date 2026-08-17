CC      := riscv32-unknown-elf-gcc
OBJCOPY := riscv32-unknown-elf-objcopy
OBJDUMP := riscv32-unknown-elf-objdump

ARCH    := -march=rv32i -mabi=ilp32
CFLAGS  := $(ARCH) -Os -ffreestanding -fno-builtin -Wall -Wextra -std=c11 -O0
ASFLAGS := $(ARCH)
LDFLAGS := -nostartfiles -Wl,--gc-sections -Tlink.ld

OBJS := start.o main.o

all: firmware.elf

firmware.elf: $(OBJS) link.ld
	$(CC) $(CFLAGS) $(OBJS) -o $@ $(LDFLAGS)


start.o: start.S
	$(CC) $(ASFLAGS) -c $< -o $@

main.o: main.c
	$(CC) $(CFLAGS) -c $< -o $@

bin: firmware.elf

	$(OBJCOPY) -O binary $< firmware.bin

dis: firmware.elf
	$(OBJDUMP) -D $< | less


clean:
	rm -f *.o *.elf *.bin

