# Verification Record

## Environment

- Date: 2026-06-09
- Vivado version: Vivado v2023.2, SW Build 4029153, IP Build 4028589
- OS: Windows PowerShell environment
- Board: Not tested
- Clock frequency: Not tested
- Commit hash before this record update: `b0f4ea4`
- Memory image source: Excluded pending authorization review
- IROM file: Not included
- DRAM file: Not included

## Test Type

- [ ] XSim simulation
- [ ] Post-synthesis simulation
- [ ] Board run
- [x] Other: Vivado project reconstruction only

## Project Reconstruction

- Command: `source fpga/vivado/create_project.tcl`
- Vivado launch path: local Vivado 2023.2 installation provided by the maintainer
- Result: Project creation completed with Vivado batch exit code 0.
- Generated project path during test: `build/vivado`
- Temporary generated files: local Vivado project files under `build/vivado`; removed after inspection and not committed.

## Reconstruction Checks

- RTL files added: Yes, 32 copied RTL source files were present in the generated project.
- Testbench files added: Yes, `tb_top.sv`, `tb_myCPU.sv`, and `tb_uart.sv` were present in the generated project.
- XDC added: Yes, `fpga/constraints/digital_twin.xdc` was present in the generated project.
- XCI/IP added: Partial. `IROM`, `DRAM`, and `pll` were imported successfully.
- Synthesis top: `top`
- Simulation top: `tb_top`

## IP and Memory Findings

- `pll_1/pll.xci` was not imported by default after review because it conflicts with the existing IP name `pll` and the copied RTL does not instantiate `pll_1`.
- `counter_0/counter_0.xci` and `counter_1/counter_1.xci` were not imported by default after review because they reference a custom `counter (1.0)` IP definition that is not present in the standard Vivado 2023.2 catalog, and the copied RTL uses `rtl/peripherals/counter.sv` instead.
- Vivado reported skipped external `irom.coe` and `dram.coe` files while importing IROM/DRAM IP. This is expected because memory initialization files are excluded pending authorization review.
- Vivado warned that the checkout path is long for Windows path handling. A shorter checkout path is recommended for future rebuild tests.

## RV32I Instruction Test

- Expected pass count: 37
- Observed pass count: Not tested
- SEG display: Not tested
- LED display: Not tested
- Log file: None committed
- Screenshot/waveform: None

## Performance Test

- Counter start command observed: Not tested
- Counter stop command observed: Not tested
- SEG displayed time: Not tested
- Computation result correct: Not tested
- Evidence: None

## Notes

This record verifies only that Vivado 2023.2 can create the project and load the default source set, simulation files, XDC, and the IP files currently instantiated by RTL. It is not a CPU correctness record.

Memory initialization files remain excluded pending authorization review, so no RV32I 37/37 or performance claim is made.

## Known Issues

- XCI/IP regeneration has not been validated through synthesis or simulation.
- Program-dependent simulation was not run because memory initialization files are not included.
- No board run was performed.
- Licensing of XDC, XCI, testbench, helper modules, and memory files still requires human confirmation.

## Conclusion

- [ ] Pass
- [ ] Fail
- [x] Partial
