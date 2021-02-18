Commands to use Linker Script

		riscv32-unknown-elf-gcc -g -c <C file name>.c

		riscv32-unknown-elf-ld -o output -T script.lds <C file name>.o

		riscv32-unknown-elf-objdump -D output >> output.txt
