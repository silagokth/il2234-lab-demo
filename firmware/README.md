# Firmware compilation

The program that is provided here and will be used for examination is ***main.c***. Make sure you have RISC-V GNU Toolchain installed in your system.

To build the assembly code, run:

```
make all 
```

To view the ELF generated, run:
  
```
riscv32-unknown-elf-objdump -d firmware.elf | less
```

To generate the COE file for the FPGA memory initialization, run:

```
./elf2coe.sh 
```
