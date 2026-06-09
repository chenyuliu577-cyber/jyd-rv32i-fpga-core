# JYD RV32I FPGA Core

An educational RV32I FPGA CPU/SoC project organized around the JYD RISC-V contest requirements.

This repository is an early-stage, educational, competition-oriented cleanup of a Vivado/SystemVerilog project. It is intended for learning digital design, computer organization, RV32I CPU structure, FPGA SoC integration, simulation, and reproducible Vivado project reconstruction.

This is an independent educational cleanup of a contest-oriented project. It is not an official JYD repository unless explicitly stated.

## Current Status

- Scope: RV32I contest-oriented CPU/SoC for FPGA.
- RTL status: source files have been copied from the working project without changing CPU logic.
- Verification status: the repository does not yet include a reproducible report proving 37/37 instruction-test pass. Treat RV32I pass count and performance results as to be added until logs or board records are available.
- Project maturity: early-stage educational release, not an industrial-grade or fully verified core.

This project does not claim RV32IM support, full formal verification, production readiness, external user adoption, CI status, releases, stars, or benchmark leadership.

## Contest Specification Summary

The referenced JYD contest requirements target the RV32I base integer ISA. The contest instruction test covers 37 instructions. `fence`, `ebreak`, and `ecall` are not tested by the contest and may be implemented as no-ops or documented as reserved behavior.

Memory and peripheral map summary:

| Region | Address range | Notes |
| --- | --- | --- |
| IROM | `0x8000_0000` to `0x800F_FFFF` | Contest memory region |
| IROM implemented area | `0x8000_0000` to `0x8000_3FFF` | 16 KB read-only IROM |
| DRAM | `0x8010_0000` to `0x801F_FFFF` | Contest memory region |
| DRAM implemented area | `0x8010_0000` to `0x8013_FFFF` | 256 KB read-write DRAM |
| SW | `0x8020_0000` to `0x8020_0007` | Read-only switches |
| KEY | `0x8020_0010` to `0x8020_0013` | Read-only keys |
| SEG | `0x8020_0020` to `0x8020_0023` | Read-write seven-segment display |
| LED | `0x8020_0040` to `0x8020_0043` | Write-only LED output |
| Counter | `0x8020_0050` to `0x8020_0053` | Read-write performance counter |

The CPU-facing interface includes `cpu_rst`, `cpu_clk`, `irom_addr`, `irom_data`, `perip_addr`, `perip_wen`, `perip_mask`, `perip_wdata`, and `perip_rdata`.

## Repository Layout

```text
rtl/core/          CPU top-level and core logic
rtl/pipeline/      IFU, IDU, EXU, LSU, WBU, hazard, predictor, pipeline regs
rtl/soc/           top, student_top, peripheral bridge, DRAM driver
rtl/peripherals/   counter, UART, seven-segment display, twin controller
rtl/common/        small shared helper modules
tb/                XSim-oriented testbenches
fpga/constraints/  XDC constraints
fpga/ip/           Vivado XCI configuration files
fpga/ip-optional/  copied XCI files retained for audit, not imported by default
fpga/vivado/       project reconstruction Tcl
mem/               user-supplied memory initialization files
docs/              architecture, verification, Vivado, and release notes
scripts/           repository hygiene scripts
```

## Quick Start

1. Review `mem/README.md` and provide your own memory initialization files.
   Private memory files must live under `mem/` as `mem/irom.coe`,
   `mem/dram.coe`, `mem/IROM.mif`, or `mem/DRAM.mif`, and must not be
   committed.
2. Run the clean-repository check:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/check_clean_repo.ps1
```

3. Recreate the Vivado project:

```tcl
cd <repo-root>
source fpga/vivado/create_project.tcl
```

4. In Vivado, verify that IROM/DRAM IP initialization points to your local memory files before simulation or bitstream generation.

## Vivado Reconstruction

The recommended entry point is `fpga/vivado/create_project.tcl`. It uses relative paths, adds RTL, testbench files, XDC constraints, and the checked-in XCI files, then sets `top` as the synthesis top and `tb_top` as the simulation top.

Prerequisites:

- Vivado installed and available from Vivado Tcl shell or command line.
- FPGA part support for `xc7k325tffg900-2`.
- User-provided memory initialization files when running program-dependent simulation or implementation.
- A reasonably short local checkout path is recommended because Vivado warns on long Windows paths.

If an IP cannot regenerate in a fresh Vivado installation, update the Tcl script with explicit IP creation commands and document the required parameters. Do not commit generated IP output directories.

The script creates local build output under `build/vivado`. This directory is ignored and should not be committed.

The script currently imports the IPs instantiated by the copied RTL: `IROM`, `DRAM`, and `pll`. Additional copied XCI files under `fpga/ip-optional/` are retained for audit but are not imported by default unless their need and IP repository requirements are confirmed.

When memory initialization files are not present, the reconstruction script reports this as the expected public-repository state. If private files are present under `mem/`, manually confirm that IROM/DRAM IP initialization points to `mem/irom.coe` and `mem/dram.coe` before simulation or bitstream generation.

## Simulation

Current testbenches:

- `tb/tb_myCPU.sv`
- `tb/tb_top.sv`
- `tb/tb_uart.sv`

The original working directory contained XSim output and waveform files, but generated simulation products are intentionally excluded. See `docs/simulation.md` for the intended workflow.

## Verification

The expected verification target is:

- RV32I instruction test: 37/37 pass.
- Performance test: correct computation result and counter display.
- Display behavior: SEG and LED output match the contest requirement.

The public cleanup currently does not include a reproducible verification report. See `docs/verification.md` and `docs/verification-record-template.md` for the planned evidence format.

## Performance

The performance counter is memory-mapped at `0x8020_0050`. According to the contest specification, writing `0x8000_0000` to the counter address starts counting, and writing `0xFFFF_FFFF` ends counting.

The current repository still needs RTL-level and simulation-level evidence proving that the implementation fully matches that specification. Seven-segment display timing in milliseconds is part of the contest output behavior.

No official performance number is included yet.

## Before Public Release

- Confirm file licensing.
- Add at least one reproducible simulation or board verification record.
- Validate `fpga/vivado/create_project.tcl` on a clean machine.
- Run `scripts/check_clean_repo.ps1`.
- Review `docs/packaging.md` before creating a source archive.
- Confirm XCI/IP regeneration.

## Maintainer Notes

- Do not commit generated Vivado artifacts.
- Do not commit contest memory images unless redistribution rights are confirmed.
- Do not hard-code behavior for fixed IROM/DRAM programs.

## Known Limitations

- Memory initialization files are excluded pending authorization review.
- XCI files may still require manual Vivado/IP validation.
- No public 37/37 verification artifact is included yet.
- No CI workflow is included yet.
- Some testbench comments may contain encoding artifacts inherited from the working project.
- Licensing of XDC, XCI, testbench, and memory material must be confirmed before a public release.

## Roadmap

See `docs/roadmap.md`.

## Contributing

Contributions should include clear verification evidence and must not target fixed test programs with hard-coded behavior. See `CONTRIBUTING.md`.

## License

The repository uses the MIT License for files confirmed as original project work. Contest-provided materials, generated Vivado files, memory initialization programs, and third-party code are excluded unless redistribution rights are confirmed.

See `THIRD_PARTY_NOTICES.md` for current licensing cautions and files requiring human confirmation.
