  .section .init
  .globl _start
_start:
  /* set stack */
  la   sp, _sstack

  /* copy .data from ROM (_sidata) to RAM [_sdata, _edata) */

  la   a0, _sdata
  la   a1, _edata
  la   a2, _sidata

1:
  beq  a0, a1, 2f
  lw   t0, 0(a2)
  sw   t0, 0(a0)
  addi a0, a0, 4
  addi a2, a2, 4
  j    1b

  /* zero .bss in RAM [_sbss, _ebss) */
2:
  la   a0, _sbss
  la   a1, _ebss
  li   t0, 0

3:
  beq  a0, a1, 4f
  sw   t0, 0(a0)
  addi a0, a0, 4
  j    3b

  /* jump to C */

4:
  call main

  /* if main returns, spin */
5:
  j    5b

