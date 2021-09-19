AS = nasm
RMFLAGS = -f bin
BOOTBIN = bootcode.bin
STAGE2  = boot/stage2/stage2.bin.temp
FRIENDLY = friendly.bin
ISO = Friendly.iso

all: $(ISO)
	@printf "Built friendly\n";

$(ISO):
	$(AS) $(RMFLAGS) boot/stage1.asm -o $(FRIENDLY)
	rm -rf iso || echo ""
	mkdir iso
	truncate $(FRIENDLY) -s 1200k
	cp $(FRIENDLY) iso/
	mkisofs -b $(FRIENDLY) -o iso/$@ iso/

run:
	qemu-system-x86_64 -hda $(FRIENDLY) --no-shutdown --no-reboot -d int

run_iso:
	qemu-system-x86_64 -cdrom iso/$(ISO) --no-shutdown --no-reboot -d int

clean:
	rm $(FRIENDLY)
