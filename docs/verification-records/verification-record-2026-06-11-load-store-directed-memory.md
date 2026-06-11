# Verification Record: Load/Store Directed Public Memory Test

## Environment

- Date: 2026-06-11
- Vivado version: Vivado v2023.2, SW Build 4029153
- OS: Microsoft Windows 11 Home Chinese Edition, 10.0.26200, 64-bit
- Board: Not used; XSim behavioral simulation only
- Commit hash: 72a1df3567c927f77bd84fe0cb7023ad535f9428
- Memory image source: public self-generated load-store directed memory
- IROM file: `tests/load-store-memory/irom.coe`
- DRAM file: `tests/load-store-memory/dram.coe`
- Memory profile: `JYD_MEMORY_PROFILE=load-store`

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
- Memory initialization confirmed: Yes, Vivado log reported `Using load/store directed memory images from tests/load-store-memory/ because JYD_MEMORY_PROFILE=load-store`

## Load/Store Directed Test

- Expected success SEG raw value: `0x0000C0DE`
- Expected failure SEG raw value: `0x0000BAD0`
- Expected success LED raw value: `0x00000001`
- Expected failure LED raw value: `0x000000EE`
- Observed SEG raw value: `0x0000C0DE`
- Observed LED raw value: `0x00000001`
- Observed PC: `0x8000008C`
- Observed instruction at final loop: `0x0000006F`
- Interpreted result: Pass; XSim reached the success final self-loop.
- Evidence summary: XSim reached the final `JAL` self-loop and the internal `perip_bridge.seg_wdata` success marker was observed as `0x0000C0DE`. The external `virtual_seg` signal is seven-segment encoded output, so the raw SEG value was read from `bridge_inst.seg_wdata`.
- Full logs committed: No
- Memory files committed: Yes, public self-generated load/store directed COE files only
- Private memory files committed: No

## Coverage Intent

- `SW / LW` word store-load
- `SH / LH` signed halfword load
- `SH / LHU` unsigned halfword load
- `SB / LB` signed byte load
- `SB / LBU` unsigned byte load
- basic DRAM offset access
- basic sign extension and zero extension behavior

## Limitations

This record does not claim RV32I 37/37 correctness. It does not cover all
load/store boundary cases, exception handling, or misaligned accesses. It only
records the public load/store directed memory test result observed in XSim.

## Conclusion

- [x] Pass
- [ ] Fail
- [ ] Partial
