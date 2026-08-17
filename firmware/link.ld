/* 64 KiB total: 0x0000_0000 .. 0x0000_FFFF
   - ROM 32 KiB: 0x0000_0000 .. 0x0000_7FFF
   - RAM 32 KiB: 0x0000_8000 .. 0x0000_FFFF */


ENTRY(_start)

MEMORY {

  ROM (rx)  : ORIGIN = 0x00000000, LENGTH = 32K
  RAM (rwx) : ORIGIN = 0x00008000, LENGTH = 32K
}

/* Exposed symbols for startup */
_sstack = ORIGIN(RAM) + LENGTH(RAM); /* stack grows down */

SECTIONS {
  .text : {
    KEEP(*(.init))         /* reset vector / start */
    *(.text*)              /* code */
    *(.rodata*)            /* const data */
    . = ALIGN(4);
    _etext = .;            /* end of text/rodata */
  } > ROM

  /* Initialized data lives in RAM but is *loaded* from ROM.
     The LOADADDR(.data) is captured by _sidata. */
  .data : AT (ADDR(.text) + SIZEOF(.text)) {
    . = ALIGN(4);
    _sdata = .;            /* start of data in RAM */

    *(.data*)
    . = ALIGN(4);
    _edata = .;            /* end of data in RAM */
  } > RAM
  _sidata = LOADADDR(.data); /* where to copy from in ROM */

  /* Zero-initialized */
  .bss (NOLOAD) : {
    . = ALIGN(4);
    _sbss = .;
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);

    _ebss = .;
  } > RAM

  /* Simple 4 KiB stack at top of RAM (optional guard) */
  . = ORIGIN(RAM) + LENGTH(RAM);
  . = . - 0x1000;
  _stack_top = . + 0x1000; /* = _sstack */
}

