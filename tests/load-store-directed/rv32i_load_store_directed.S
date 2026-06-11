# Public RV32I load/store directed test.
# This source documents the machine-code program emitted by
# tools/gen_load_store_directed_memory.py. The generator is the source of truth
# for the COE memory image and does not call riscv-gcc.
#
# Coverage intent:
# - SW / LW word store-load
# - SH / LH signed halfword load
# - SH / LHU unsigned halfword load
# - SB / LB signed byte load
# - SB / LBU unsigned byte load
# - Basic DRAM offset access
# - Basic sign extension and zero extension behavior
#
# Success: SEG raw 0x0000C0DE, LED raw 0x00000001.
# Failure: SEG raw 0x0000BAD0, LED raw 0x000000EE.
# This is not complete RV32I 37/37 verification.

    lui  x1, 0x80100        # x1 = DRAM base 0x80100000
    lui  x2, 0x80200        # x2 = peripheral base 0x80200000

    lui  x3, 0x12345        # x3 = 0x12345000
    addi x3, x3, 0x678      # x3 = 0x12345678
    sw   x3, 0(x1)          # SW word case
    nop
    lw   x4, 0(x1)          # LW word case
    bne  x4, x3, fail

    lui  x5, 0x00008        # x5 = 0x00008000
    addi x5, x5, 1          # x5 = 0x00008001
    sh   x5, 4(x1)          # SH lower halfword
    nop
    lh   x6, 4(x1)          # LH signed, expect 0xffff8001
    lui  x7, 0xffff8        # x7 = 0xffff8000
    addi x7, x7, 1          # x7 = 0xffff8001
    bne  x6, x7, fail

    sh   x5, 6(x1)          # SH upper halfword
    nop
    lhu  x6, 6(x1)          # LHU unsigned, expect 0x00008001
    bne  x6, x5, fail

    addi x8, x0, 0x80       # x8 = 0x00000080
    sb   x8, 8(x1)          # SB byte lane 0
    nop
    lb   x9, 8(x1)          # LB signed, expect 0xffffff80
    addi x10, x0, -128      # x10 = 0xffffff80
    bne  x9, x10, fail

    sb   x8, 11(x1)         # SB byte lane 3
    nop
    lbu  x9, 11(x1)         # LBU unsigned, expect 0x00000080
    bne  x9, x8, fail

success:
    lui  x6, 0x0000c        # prepare 0x0000c000
    addi x6, x6, 0x0de      # x6 = 0x0000c0de
    sw   x6, 0x20(x2)       # write success SEG marker
    addi x7, x0, 1          # success LED marker
    sw   x7, 0x40(x2)       # write success LED marker
success_loop:
    jal  x0, success_loop

fail:
    lui  x6, 0x0000c        # prepare 0x0000c000
    addi x6, x6, -1328      # x6 = 0x0000bad0
    sw   x6, 0x20(x2)       # write failure SEG marker
    addi x7, x0, 238        # failure LED marker
    sw   x7, 0x40(x2)       # write failure LED marker
fail_loop:
    jal  x0, fail_loop
