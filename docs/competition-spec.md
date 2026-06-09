# Competition Specification Notes

This document summarizes the contest-facing requirements used by this project. It is not a verbatim copy of the contest PDF. Refer to the official contest PDF for authoritative wording.

## Instruction Requirement

The contest minimum target is the RV32I base integer instruction-set test. RV32I contains 40 base instructions. The contest instruction test covers 37 instructions and does not test:

- `fence`
- `ebreak`
- `ecall`

The tested 37 instructions are expected to include:

- Upper immediates: `lui`, `auipc`
- Jumps: `jal`, `jalr`
- Branches: `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`
- Loads: `lb`, `lh`, `lw`, `lbu`, `lhu`
- Stores: `sb`, `sh`, `sw`
- Immediate ALU: `addi`, `slti`, `sltiu`, `xori`, `ori`, `andi`
- Shifts immediate: `slli`, `srli`, `srai`
- Register ALU: `add`, `sub`, `sll`, `slt`, `sltu`, `xor`, `srl`, `sra`, `or`, `and`

`fence`, `ebreak`, and `ecall` should be documented as untested by the contest. If implemented as no-ops or reserved instructions, that behavior must be stated clearly.

## Address Space

| Region | Address range | Access |
| --- | --- | --- |
| IROM | `0x8000_0000` to `0x800F_FFFF` | Region requirement |
| 16 KB IROM | `0x8000_0000` to `0x8000_3FFF` | Read-only |
| DRAM | `0x8010_0000` to `0x801F_FFFF` | Region requirement |
| 256 KB DRAM | `0x8010_0000` to `0x8013_FFFF` | Read-write |
| SW | `0x8020_0000` to `0x8020_0007` | Read-only |
| KEY | `0x8020_0010` to `0x8020_0013` | Read-only |
| SEG | `0x8020_0020` to `0x8020_0023` | Read-write |
| LED | `0x8020_0040` to `0x8020_0043` | Write-only |
| Counter | `0x8020_0050` to `0x8020_0053` | Read-write |

Counter command summary:

- Write `0x8000_0000`: start counting.
- Write `0xFFFF_FFFF`: end counting, according to the contest request text. The current copied RTL needs review because the stop command definition was not confirmed during cleanup.

## CPU Interface

The contest CPU interface includes:

| Signal | Direction from CPU | Purpose |
| --- | --- | --- |
| `cpu_rst` | input | Reset |
| `cpu_clk` | input | CPU clock |
| `irom_addr` | output | IROM address |
| `irom_data` | input | IROM read data |
| `perip_addr` | output | DRAM/peripheral address |
| `perip_wen` | output | Write enable |
| `perip_mask` | output | Write mask |
| `perip_wdata` | output | Write data |
| `perip_rdata` | input | Read data |

## Timing Notes

- Default `cpu_clk` is 50 MHz.
- The clock may be changed through PLL output configuration, but this repository does not claim timing closure for arbitrary frequencies.
- IROM is a Vivado distributed RAM IP. Given an address, data is available in the current cycle according to the contest request.
- Peripheral reads complete in the current cycle.
- Peripheral writes take effect in the next cycle and are controlled by `perip_wen`.

## Test and Display Rules

The preliminary contest tests include:

- RV32I instruction-set test.
- Performance test.

Expected display behavior:

- The left two seven-segment digits show the RV32I pass count.
- The right six seven-segment digits show performance-test execution time in milliseconds.
- LED output should match the expected performance-test pattern.

The target end state is 37/37 instruction pass, correct performance-test computation, correct LED pattern, and SEG timing display. This repository has not yet added a public reproducible report proving that state.

