# Verification Record: Branch Directed Public Memory Test

## Environment

- Date: 2026-06-11
- Vivado version: Vivado v2023.2, SW Build 4029153
- OS: Microsoft Windows 11 Home Chinese Edition, 10.0.26200, 64-bit
- Board: Not used; XSim behavioral simulation only
- Commit hash: cb061a3672bcfecab5e8e541ca461ed7b2350088
- Memory image source: public self-generated branch-directed memory
- IROM file: `tests/branch-memory/irom.coe`
- DRAM file: `tests/branch-memory/dram.coe`
- Memory profile: `JYD_MEMORY_PROFILE=branch`

## Test Type

- [x] XSim simulation
- [ ] Board run
- [ ] Other:

## Project Reconstruction

- Vivado project creation: Succeeded
- RTL loaded: Yes
- Testbench loaded: Yes, `tb_top`
- XDC loaded: Yes
- IROM/DRAM IP loaded: Yes
- Memory initialization confirmed: Yes, Vivado log reported `Using branch directed memory images from tests/branch-memory/ because JYD_MEMORY_PROFILE=branch`

## Branch Directed Test

- Expected success SEG raw value: `0x0000BEEF`
- Expected failure SEG raw value: `0x0000BAD0`
- Expected success LED raw value: `0x00000001`
- Expected failure LED raw value: `0x000000EE`
- Observed SEG raw value: `0x0000BEEF`
- Observed LED raw value: `0x00000001`
- Observed PC: `0x800000B4`
- Observed instruction at final loop: `0x0000006F`
- Evidence summary: XSim reached the final `JAL` self-loop and the internal `perip_bridge.seg_wdata` success marker was observed as `0x0000BEEF`. The external `virtual_seg` signal is seven-segment encoded output, so the raw SEG value was read from `bridge_inst.seg_wdata`.
- Full logs committed: No
- Memory files committed: Yes, public self-generated branch-directed COE files only
- Private memory files committed: No

## Coverage Intent

- BEQ taken
- BEQ not taken
- BNE taken
- BNE not taken
- BLT signed taken
- BGE signed taken
- BLTU unsigned taken
- BGEU unsigned taken
- JAL final self-loop

## Limitations

This record does not claim RV32I 37/37 correctness. It only records the public branch-directed memory smoke test result observed in XSim.

## Conclusion

- [x] Pass
- [ ] Fail
- [ ] Partial
