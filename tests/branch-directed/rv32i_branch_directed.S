# Public self-generated RV32I branch directed test source.
# This is documentation for tools/gen_branch_directed_memory.py, which directly
# emits the matching machine words without requiring an external assembler.

.section .text
.globl _start

_start:
    lui   x1, 0x80200          # x1 = peripheral base 0x80200000
    addi  x10, x0, 0           # score = 0

    addi  x2, x0, 5
    addi  x3, x0, 5
    beq   x2, x3, beq_taken_ok
    jal   x0, fail
beq_taken_ok:
    addi  x10, x10, 1

    addi  x2, x0, 5
    addi  x3, x0, 6
    beq   x2, x3, fail
    addi  x10, x10, 2

    bne   x2, x3, bne_taken_ok
    jal   x0, fail
bne_taken_ok:
    addi  x10, x10, 4

    addi  x2, x0, 7
    addi  x3, x0, 7
    bne   x2, x3, fail
    addi  x10, x10, 8

    addi  x2, x0, -1
    addi  x3, x0, 1
    blt   x2, x3, blt_taken_ok
    jal   x0, fail
blt_taken_ok:
    addi  x10, x10, 16

    addi  x2, x0, 1
    addi  x3, x0, -1
    bge   x2, x3, bge_taken_ok
    jal   x0, fail
bge_taken_ok:
    addi  x10, x10, 32

    addi  x2, x0, 1
    addi  x3, x0, -1
    bltu  x2, x3, bltu_taken_ok
    jal   x0, fail
bltu_taken_ok:
    addi  x10, x10, 64

    addi  x2, x0, -1
    addi  x3, x0, 1
    bgeu  x2, x3, bgeu_taken_ok
    jal   x0, fail
bgeu_taken_ok:
    addi  x10, x10, 128

    addi  x11, x0, 255
    bne   x10, x11, fail

success:
    lui   x6, 0x0000c          # x6 = 0x0000c000
    addi  x6, x6, -273         # x6 = 0x0000beef
    sw    x6, 0x20(x1)         # SEG success marker
    addi  x7, x0, 1
    sw    x7, 0x40(x1)         # LED success marker
success_loop:
    jal   x0, success_loop

fail:
    lui   x6, 0x0000c          # x6 = 0x0000c000
    addi  x6, x6, -1328        # x6 = 0x0000bad0
    sw    x6, 0x20(x1)         # SEG failure marker
    addi  x7, x0, 238
    sw    x7, 0x40(x1)         # LED failure marker
fail_loop:
    jal   x0, fail_loop
