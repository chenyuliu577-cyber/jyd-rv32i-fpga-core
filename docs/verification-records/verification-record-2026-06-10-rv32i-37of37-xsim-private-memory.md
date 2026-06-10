# Verification Record: RV32I 37/37 XSim Private Memory

## Environment

- Date: 2026-06-10
- Vivado version: Vivado v2023.2, SW Build 4029153, IP Build 4028589
- OS: Windows
- Commit hash: based on `221dc6c` plus the `fix/reproducible-xsim-flow` working-tree Tcl changes recorded in this commit
- Memory image source: private, not committed
- IROM file: `mem/irom.coe`, ignored
- DRAM file: `mem/dram.coe`, ignored

## Project Reconstruction

- `create_project.tcl`: succeeded with exit code 0
- RTL loaded: yes
- Testbench loaded: yes
- XDC loaded: yes
- IROM/DRAM IP memory binding: `CONFIG.coefficient_file` bound to `mem/irom.coe` and `mem/dram.coe`
- PLL configuration: default flow uses `fpga/ip-optional/pll_1/pll.xci` as the single `pll` IP source; this XCI provides `clk_out1`, `clk_out2`, and `locked`, matching `rtl/soc/top.sv`
- Include path configuration: `rtl/common` added to `sources_1` and `sim_1` include directories for files that include `para.sv`

## XSim Result

- Compile: pass
- Elaboration: pass
- Simulation: pass; `tb_top` ran to `$finish`
- Observed signal: `/tb_top/uut/student_top_inst/bridge_inst/seg_wdata`
- Observed value: `32'h37000000`
- Expected RV32I pass display: `37`
- Result: RV32I 37/37 display observed in XSim with private memory images

## Evidence Summary

The XSim batch run reached `$finish` in `tb/tb_top.sv`. The internal SEG write
data signal was observed as `32'h37000000`, interpreted as the RV32I 37/37
display. The encoded top-level `virtual_seg` value was observed as
`40'h41d3f4fd3f`.

No private memory image, full Vivado log, XSim log, waveform, WDB, bitstream, or
DCP file is committed. This verification depends on private local memory images
under `mem/`.

## Conclusion

- [x] Pass
- [ ] Partial
- [ ] Fail
