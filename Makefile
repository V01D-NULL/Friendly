AS = nasm
RMFLAGS = -f bin
FRIENDLY = friendly.bin
ISO = Friendly.iso
BRANCH_HASH = $(shell git rev-parse main | head -c 7)

all: $(ISO)
	@printf "(OK) Built friendly\n";

write_git_hash:
	@$(shell head -n -1 boot/stage2.asm > boot/stage2.asm.temp)
	@rm boot/stage2.asm
	@mv boot/stage2.asm.temp boot/stage2.asm
	@echo 'bootloader_msg: db "(Friendly) Version: $(BRANCH_HASH)", 0' >> boot/stage2.asm

$(ISO): write_git_hash
	$(AS) $(RMFLAGS) boot/stage1.asm -o $(FRIENDLY)
	rm -rf iso || echo ""
	mkdir iso
	truncate $(FRIENDLY) -s 1200k
	touch iso/kernel.elf
	cp $(FRIENDLY) iso/
	mkisofs -b $(FRIENDLY) -o iso/$@ iso/

run:
	qemu-system-x86_64 -hda $(FRIENDLY) --no-shutdown --no-reboot -d int

run_iso:
	qemu-system-x86_64 -cdrom iso/$(ISO) --no-shutdown --no-reboot -d int

clean:
	rm $(FRIENDLY)
