# Building the RV32-IM Compiler Toolchain 
We will be working with the RISC-V toolchain repos found on the Github page [RISC-V GNU Compiler Toolchain](https://github.com/riscv/riscv-gnu-toolchain).

The following installation was performed on Ubuntu 18.04 (WSL)

## Cloning 

First we recursively clone the suite of open source GNU tools for RISC-V:

`mkdir build; cd /build`

`git clone --recursive https://github.com/riscv/riscv-gnu-toolchain`

## Configuring 
We configure our build in a separate sub directory to produce a toolchain for a RV32IM.

`cd riscv-gnu-toolchain/`

`mkdir build; cd build`

 `../configure --help | grep abi`
 
 `../configure --prefix=/opt/riscv32 --with-arch=rv32im --with-abi=ilp32`
 
 ## Building the Configured Toolchain
 We use the 'make' command to build our toolchain.
 
 `make -j$(nproc)`
 
 The toolchain is successfully built if the following structure is obtained.
 
 `cd /opt/riscv32`
 
 `tree -L 3 -d`
 
 ```.
├── bin
├── include
│   └── gdb
├── lib
│   └── gcc
│       └── riscv32-unknown-elf
├── libexec
│   └── gcc
│       └── riscv32-unknown-elf
├── riscv32-unknown-elf
│   ├── bin
│   ├── include
│   │   ├── bits
│   │   ├── c++
│   │   ├── machine
│   │   ├── newlib-nano
│   │   ├── rpc
│   │   ├── ssp
│   │   └── sys
│   └── lib
│       └── ldscripts
└── share
    ├── gcc-10.1.0
    │   └── python
    ├── gdb
    │   ├── python
    │   ├── syscalls
    │   └── system-gdbinit
    ├── info
    ├── locale
    │   ├── bg
    │   ├── ca
    │   ├── da
    │   ├── de
    ... ...
    │   ├── vi
    │   ├── zh_CN
    │   └── zh_TW
    └── man
        ├── man1
        ├── man5
        └── man7
  ```
        
        
 ## Configure PATH
 For ease of use we can add the compiler we built to the PATH.
 
 `export PATH=/opt/riscv32/bin:$PATH`
 
 ## Testing build
 
 `riscv32-unknown-elf-gcc --version` must print the following message.
 
 ```
riscv32-unknown-elf-gcc (GCC) 10.2.0
Copyright (C) 2020 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 ```
 
 ## References
 
 <https://mindchasers.com/dev/rv-getting-started>
