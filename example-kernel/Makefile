CC = gcc
LD = ld
CFLAGS = -O2 -ffreestanding 
LDFLAGS = -static -nostdlib -z max-page-size=0x1000 -T link.ld
all:
	$(CC) $(CFLAGS) -c main32.c -o main32.o
	$(LD) $(LDFLAGS) main32.o -o kernel.elf
	@cp kernel.elf ../boot/friendly-exec/