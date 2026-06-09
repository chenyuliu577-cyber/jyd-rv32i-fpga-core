# Verification Record: RV32I Private Memory Test

## Environment

- Date: 2026-06-09
- Vivado version: Vivado v2023.2, SW Build 4029153, IP Build 4028589
- OS: Windows
- Board: not used in this record
- Clock frequency: not confirmed; XSim did not reach runtime
- Commit hash: f7dc398
- Memory image source: private contest-provided memory image from the local original project tree
- IROM file: private, not committed
- DRAM file: private, not committed

## Test Type

- [x] XSim simulation
- [ ] Board run
- [ ] Other:

## Project Reconstruction

- Vivado project creation: succeeded with exit code 0
- RTL loaded: yes
- Testbench loaded: yes
- XDC loaded: yes
- IROM/DRAM IP loaded: yes
- Memory initialization confirmed: partially. `mem/irom.coe` and `mem/dram.coe` were detected, but the repository Tcl did not automatically bind IROM/DRAM IP initialization. A local generated-project-only Tcl run manually set `CONFIG.coefficient_file` for IROM and DRAM to the files under `mem/`.

## RV32I Instruction Test

- Expected pass count: 37
- Observed pass count: not observed
- SEG display: not observed
- LED display: not observed
- Evidence summary: Vivado project reconstruction succeeded. The first XSim attempt failed before simulation because IROM/DRAM IP still referenced the old `fpga/imports/test_src/*.coe` paths. After manually binding the generated Vivado project to private files under `mem/` and adding `rtl/common` as an include directory in the generated project, compilation passed but elaboration failed because `rtl/soc/top.sv` connects `pll.clk_out2`, while the default generated `pll` simulation model from `fpga/ip/pll/pll.xci` exposes only `clk_out1`. The CPU did not reach instruction execution in this record.
- Full logs committed: No
- Memory files committed: No

## Performance Test

- Counter start command observed: no
- Counter stop command observed: no
- SEG displayed time: not observed
- Computation result correct: not verified
- Evidence summary: Performance test not verified in this record because XSim did not pass elaboration and no board run was performed.

## Issues Found

- IROM/DRAM IP initialization is not automatically rebound from the public XCI paths to `mem/irom.coe` and `mem/dram.coe` by `fpga/vivado/create_project.tcl`.
- XSim needs `rtl/common` in the include path so files including `para.sv` compile correctly.
- The default `fpga/ip/pll/pll.xci` has `CLKOUT2_USED=false` and `NUM_OUT_CLKS=1`, but `rtl/soc/top.sv` connects the `clk_out2` port. This blocks XSim elaboration.

## Conclusion

- [ ] Pass
- [ ] Fail
- [x] Partial
