OUTPUT_FORMAT(elf32-little)
ENTRY(entry)

SECTIONS
{
    . = 0x10000;
    .text : ALIGN(4096)
    {
        *(.text)
    }

    .data : ALIGN(4096)
    {
        *(.data)
    }

    .bss : ALIGN(4096)
    {
        *(.bss)
    }

    .rodata : ALIGN(4096)
    {
        *(.rodata)
    }
}