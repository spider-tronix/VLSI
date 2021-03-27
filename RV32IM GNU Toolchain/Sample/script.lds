SEARCH_DIR("/opt/riscv32if/riscv32-unknown-elf/lib");
MEMORY
{
  ram      (rwx) : ORIGIN = 0x00000000, LENGTH = 0x0020000
  rom      (rx) : ORIGIN = 0x00003000, LENGTH = 0x20000000

}
SECTIONS
{
	.data :
    {
    	*(.rodata*)
        *(.data*);
    } > ram
    .bss (NOLOAD) :
    {
        *(.bss*)
        *(COMMON)
    } > ram
    .text :
    {
    	KEEP(*(.vector*))
    	*(.text*)
    } > rom
    _end = . ;
}