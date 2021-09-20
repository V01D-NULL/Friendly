# Friendly bootloader

`Friendly` is an experimental bootloader written entirely in x86 assembly, it is meant to boot kernel's given it's elf file.

How would it boot: (Note: This hasn't been implemented yet, it's a just gameplan)
- Move the kernel elf to `boot/friendly-exec/kernel.elf`, the rest is a matter of executing `make` and `make run`

### Goals:    
- Support a popular (stivale, multiboot, ...) or custom boot protocol
    
- Load and execute a kernel's elf file
    
- Support 64 bit kernels only (maybe 32 for the start)

### Features:
- It can't do anything yet, I just started this :^)