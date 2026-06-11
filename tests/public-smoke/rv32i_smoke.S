# Public self-generated RV32I smoke test source.
# This is documentation for tools/gen_public_smoke_memory.py, which directly
# emits the matching machine words without requiring an external assembler.

.section .text
.globl _start

_start:
    lui   x1, 0x80200       # x1 = peripheral base 0x80200000
    lui   x2, 0x80000       # x2 = counter start command 0x80000000
    sw    x2, 0x50(x1)      # counter start
    addi  x3, x0, 0x37      # x3 = SEG smoke magic value
    sw    x3, 0x20(x1)      # SEG write: 0x00000037, not RV32I 37/37
    addi  x4, x0, 1         # x4 = LED marker
    sw    x4, 0x40(x1)      # LED write
    addi  x5, x0, -1        # x5 = counter stop command 0xffffffff
    sw    x5, 0x50(x1)      # counter stop

halt:
    jal   x0, halt          # self-loop
