# Verification Record: Public Smoke Memory

## Environment

- Date: 2026-06-11
- Vivado version: Vivado v2023.2 (64-bit), SW Build 4029153
- OS: Windows
- Board: Not used
- Clock frequency: XSim behavioral simulation using project PLL model
- Commit hash: `d52419b01bbd039f51f929854bc2c8b9ace05d05`
- Memory image source: public self-generated smoke memory
- IROM file: `tests/public-memory/irom.coe`
- DRAM file: `tests/public-memory/dram.coe`

## Test Type

- [x] XSim simulation
- [ ] Board run
- [ ] Other:

## Project Reconstruction

- Vivado project creation: Pass
- RTL loaded: Yes
- Testbench loaded: Yes, `tb_top`
- XDC loaded: Yes
- IROM/DRAM IP loaded: Yes
- Memory initialization confirmed: Public smoke memory from `tests/public-memory/` selected and bound to IROM/DRAM `CONFIG.coefficient_file`

## Public Smoke Test

- Expected SEG raw write marker: `0x00000037`
- Observed SEG raw value: `0x00000037`
- Expected LED raw write marker: `0x00000001`
- Observed LED raw value: `0x00000001`
- Counter start command: Program includes write of `0x80000000` to `0x80200050`
- Counter stop command: Program includes write of `0xffffffff` to `0x80200050`
- Observed counter final enable state: `0`, consistent with stop after the start/stop sequence
- Observed PC: `0x80000024`, the public smoke self-loop location
- Evidence summary: XSim behavioral simulation compiled, elaborated, and ran. The simulation reached the self-loop after executing the public smoke program and observed the expected SEG and LED raw values. No full Vivado log, XSim log, waveform, or generated output is committed.

## Scope

This is a public smoke test only. It does not claim RV32I 37/37 coverage, full
RV32I correctness, Vivado implementation, bitstream generation, board
verification, or performance correctness.

## Conclusion

- [x] Pass
- [ ] Fail
- [ ] Partial
