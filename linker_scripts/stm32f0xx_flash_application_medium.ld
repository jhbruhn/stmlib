/*
Default linker script for STM32F0xx? (64k flash, 8k RAM)
*/

ENTRY(Reset_Handler)

_estack = 0x20002000;

_Min_Heap_Size = 0;
_Min_Stack_Size = 0x100;


MEMORY
{
  RAM (xrw)        : ORIGIN = 0x200000C0, LENGTH = 8K - 0xC0
  FLASH (rx)       : ORIGIN = 0x08002000, LENGTH = 64K - 0x2000
}

SECTIONS
{
  .isr_vector :
  {
    . = ALIGN(16);
    KEEP(*(.isr_vector))            /* Startup code */
    . = ALIGN(16);
  } >FLASH

  .flashtext :
  {
    . = ALIGN(16);
    *(.flashtext)            /* Startup code */
    . = ALIGN(16);
  } >FLASH

  .text :
  {
    . = ALIGN(16);
    *(.text)                   /* remaining code */
    *(.text.*)                 /* remaining code */
    *(.rodata)                 /* read-only data (constants) */
    *(.rodata*)
    *(.glue_7)
    *(.glue_7t)
    KEEP (*(.init))
    KEEP (*(.fini))

    . = ALIGN(4);
    __init_array_start = .;
    KEEP(*(.init_array)) /* C++ constructors */
    KEEP(*(.ctors))      /* vtable init */
    __init_array_end = .;

    . = ALIGN(16);
     _etext = .;
     _sidata = _etext;
  } >FLASH

  .data : AT ( _sidata )
  {
    . = ALIGN(16);
    _sdata = . ;
    *(.ramtext*)
    . = ALIGN(16);
    *(.data*)
    *(.data.*)
    . = ALIGN(16);
     _edata = . ;
  } >RAM

  .bss :
  {
    . = ALIGN(16);
    _sbss = .;
    *(.bss)
    *(.bss*)
    *(COMMON)
    . = ALIGN(16);
   _ebss = . ;
  } >RAM

  PROVIDE ( end = _ebss );
  PROVIDE ( _end = _ebss );

  ._user_heap_stack :
  {
    . = ALIGN(16);
    PROVIDE ( end = . );
    PROVIDE ( _end = . );
    . = . + _Min_Heap_Size;
    . = . + _Min_Stack_Size;
    . = ALIGN(16);
  } >RAM

  DISCARD :
  {
    libc.a ( * )
    libm.a ( * )
    libgcc.a ( * )
  }
}
