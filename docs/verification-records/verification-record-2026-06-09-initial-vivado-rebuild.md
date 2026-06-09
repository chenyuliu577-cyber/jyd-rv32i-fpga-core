# Verification Record

## Environment

- Date: 2026-06-09
- Vivado version: Not available in the current shell; `vivado` was not found in PATH and common local install paths checked during this run did not return `vivado.bat`.
- OS: Windows PowerShell environment
- Board: Not tested
- Clock frequency: Not tested
- Commit hash: `42fd266`
- Memory image source: Excluded pending authorization review
- IROM file: Not included
- DRAM file: Not included

## Test Type

- [ ] XSim simulation
- [ ] Post-synthesis simulation
- [ ] Board run
- [x] Other: Vivado project reconstruction attempt blocked by missing Vivado executable in the current environment

## Project Reconstruction

- Command intended: `source fpga/vivado/create_project.tcl`
- Result: Not executed in Vivado because the Vivado executable was not available in PATH and was not found in the common checked install paths.
- RTL added: Not verified by Vivado in this run.
- Testbench added: Not verified by Vivado in this run.
- XDC added: Not verified by Vivado in this run.
- XCI/IP added: Not verified by Vivado in this run.
- Synthesis top `top`: Not verified by Vivado in this run.
- Simulation top `tb_top`: Not verified by Vivado in this run.
- Temporary files generated: None from Vivado, because Vivado was not launched.

## RV32I Instruction Test

- Expected pass count: 37
- Observed pass count: Not tested
- SEG display: Not tested
- LED display: Not tested
- Log file: None
- Screenshot/waveform: None

## Performance Test

- Counter start command observed: Not tested
- Counter stop command observed: Not tested
- SEG displayed time: Not tested
- Computation result correct: Not tested
- Evidence: None

## Notes

This record is a truthful initial reconstruction attempt record, not a CPU correctness record. The repository still needs a Vivado environment to execute `fpga/vivado/create_project.tcl`, validate XCI/IP loading or regeneration, and record whether `top` and `tb_top` are set correctly.

Memory initialization files remain excluded pending authorization review, so no RV32I 37/37 or performance claim is made.

## Known Issues

- Vivado was not available in the current execution environment.
- XCI/IP regeneration has not been validated on a clean machine.
- No simulation or board run was performed.
- No memory initialization files are included.

## Conclusion

- [ ] Pass
- [x] Fail
- [ ] Partial

