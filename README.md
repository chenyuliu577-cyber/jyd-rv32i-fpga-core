# JYD RV32I FPGA Core

An educational RV32I FPGA CPU/SoC project organized around the JYD RISC-V contest requirements.

This repository is an early-stage, educational, competition-oriented cleanup of a Vivado/SystemVerilog project. It is intended for learning digital design, computer organization, RV32I CPU structure, FPGA SoC integration, simulation, and reproducible Vivado project reconstruction.

This is an independent educational cleanup of a contest-oriented project. It is not an official JYD repository unless explicitly stated.

## Current Status

- Scope: RV32I contest-oriented CPU/SoC for FPGA.
- RTL status: source files have been copied from the working project without changing CPU logic.
- Verification status: a private-memory XSim record observes the RV32I 37/37 display. The memory images are not included, so this is not a public no-memory reproduction artifact.
- Public smoke status: repository-owned public smoke memory images are included under `tests/public-memory/`. They are generated from `tools/gen_public_smoke_memory.py` and do not claim RV32I 37/37 coverage.
- Branch directed status: repository-owned branch directed memory images are generated under `tests/branch-memory/` by `tools/gen_branch_directed_memory.py`. They require explicit `JYD_MEMORY_PROFILE=branch` selection and do not claim RV32I 37/37 coverage.
- Project maturity: early-stage educational release, not an industrial-grade or fully verified core.

This project does not claim RV32IM support, full formal verification, production readiness, external user adoption, CI coverage beyond lightweight repository hygiene checks, releases, stars, or benchmark leadership.

## Public Preview Status

This repository is suitable for public preview, but not yet a formal stable release. A private-memory XSim verification record observed `seg_wdata = 32'h37000000`, corresponding to the contest-style RV32I 37/37 display. The memory initialization files used for that run are not included or redistributed.

The repository also includes a public self-generated smoke memory image. It
writes raw value `0x00000037` to SEG MMIO address `0x8020_0020` as a smoke-test
marker. This marker is not an RV32I 37/37 instruction-test result.

The repository also includes a public self-generated branch directed memory
image. It expects success SEG raw value `0x0000BEEF` and failure SEG raw value
`0x0000BAD0`. This directed test is limited to basic branch behavior and is not
complete RV32I verification.

## Contest Specification Summary

The referenced JYD contest requirements target the RV32I base integer ISA. The contest instruction test covers 37 instructions. `fence`, `ebreak`, and `ecall` are not tested by the contest and may be implemented as no-ops or documented as reserved behavior.

Memory and peripheral map summary:

See [docs/memory-map.md](docs/memory-map.md) for an editable Mermaid diagram
and address table.

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
tests/public-smoke/ public RV32I smoke-test source
tests/public-memory/ generated public smoke-test COE files
tests/branch-directed/ public RV32I branch-directed source
tests/branch-memory/ generated branch-directed COE files
tools/             repository utility scripts
```

## Quick Start

1. Regenerate the public smoke memory images if needed:

```powershell
python tools/gen_public_smoke_memory.py
```

   The generated `tests/public-memory/irom.coe` and
   `tests/public-memory/dram.coe` files are public, repository-owned smoke
   images. Private memory files, if used, must live under `mem/` as
   `mem/irom.coe`, `mem/dram.coe`, `mem/IROM.mif`, or `mem/DRAM.mif`, and must
   not be committed.
2. Run the clean-repository check:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/check_clean_repo.ps1
```

3. Recreate the Vivado project:

```tcl
cd <repo-root>
source fpga/vivado/create_project.tcl
```

4. When `mem/irom.coe` and `mem/dram.coe` are present, the Tcl flow uses those
   private files first. Otherwise, it uses the public smoke files under
   `tests/public-memory/` when they are present.

To run the public branch directed memory instead of the default public smoke
memory, regenerate the branch memory and explicitly select the branch profile:

```powershell
python tools/gen_branch_directed_memory.py
$env:JYD_MEMORY_PROFILE = "branch"
vivado -mode batch -source fpga/vivado/create_project.tcl
```

## CI Scope

This repository includes a lightweight GitHub Actions workflow for repository hygiene checks.

The current CI checks:

- repository cleanliness using `scripts/check_clean_repo.ps1`
- whitespace issues in tracked files using `git diff --check`

The current CI does not run Vivado, XSim, synthesis, implementation, bitstream generation, FPGA board tests, or RV32I correctness verification. Hardware and CPU correctness evidence must be documented separately in verification records.

## Vivado Reconstruction

The recommended entry point is `fpga/vivado/create_project.tcl`. It uses relative paths, adds RTL, testbench files, XDC constraints, and the checked-in XCI files, then sets `top` as the synthesis top and `tb_top` as the simulation top.

Prerequisites:

- Vivado installed and available from Vivado Tcl shell or command line.
- FPGA part support for `xc7k325tffg900-2`.
- User-provided memory initialization files when running program-dependent simulation or implementation.
- A reasonably short local checkout path is recommended because Vivado warns on long Windows paths.

If an IP cannot regenerate in a fresh Vivado installation, update the Tcl script with explicit IP creation commands and document the required parameters. Do not commit generated IP output directories.

The script creates local build output under `build/vivado`. This directory is ignored and should not be committed.

The script currently imports the IPs instantiated by the copied RTL: `IROM`, `DRAM`, and `pll`. The default PLL source is `fpga/ip-optional/pll_1/pll.xci` because it provides both `clk_out1` and `clk_out2`, matching `rtl/soc/top.sv`. Additional copied XCI files under `fpga/ip-optional/` are retained for audit but are not imported by default unless their need and IP repository requirements are confirmed.

The reconstruction script prefers private `mem/irom.coe` and `mem/dram.coe`
files when they are present. If those private files are absent, it uses the
public smoke memory images under `tests/public-memory/` by default. Set
`JYD_MEMORY_PROFILE=branch` to explicitly use public branch directed memory
under `tests/branch-memory/`. If the selected source is unavailable, it warns
that simulation may not run meaningful CPU code.

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

The repository includes a private-memory XSim verification record observing
`seg_wdata = 32'h37000000`, interpreted as the RV32I 37/37 display. The private
memory images are excluded from Git. The public smoke memory writes raw value
`0x00000037` to SEG as a minimal path marker only; it is not an RV32I 37/37
result. The public branch directed memory writes `0x0000BEEF` on success and
`0x0000BAD0` on failure for directed branch cases only. See
`docs/verification.md` and `docs/verification-record-template.md` for the
evidence format.

## Performance

The performance counter is memory-mapped at `0x8020_0050`. According to the contest specification, writing `0x8000_0000` to the counter address starts counting, and writing `0xFFFF_FFFF` ends counting.

The current repository still needs RTL-level and simulation-level evidence proving that the implementation fully matches that specification. Seven-segment display timing in milliseconds is part of the contest output behavior.

Performance numbers are not claimed unless accompanied by a verification
record that identifies the commit hash, memory image source, environment, and
whether the result came from simulation or a board run. See
`docs/performance.md` and `docs/performance-verification-template.md`.

No official performance number is included yet.

## Before Public Release

- Confirm file licensing.
- Keep the private-memory XSim verification record, and add a public-memory or authorized-memory release record before a formal release.
- Validate `fpga/vivado/create_project.tcl` on a clean machine.
- Run `scripts/check_clean_repo.ps1`.
- Review `docs/packaging.md` before creating a source archive.
- Confirm XCI/IP regeneration.

## Maintainer Notes

- Do not commit generated Vivado artifacts.
- Do not commit contest memory images unless redistribution rights are confirmed.
- Do not hard-code behavior for fixed IROM/DRAM programs.

## Known Limitations

- Private contest memory initialization files are excluded pending authorization review.
- Private-memory XSim reached the RV32I 37/37 display, but the public repository still does not include redistributable memory images.
- Public smoke memory is self-generated from repository-owned source and only checks a minimal reproducible path.
- Public branch directed memory is self-generated from repository-owned source and only checks selected branch cases.
- XCI files may still require manual Vivado/IP validation.
- The checked-in Vivado `.xci` files are included for public-preview reconstruction convenience. Their source and redistribution status still require human confirmation before a formal release. Generated Vivado IP outputs are intentionally excluded.
- CI is limited to lightweight repository hygiene and whitespace checks.
- Some testbench comments may contain encoding artifacts inherited from the working project.
- Licensing of XDC, XCI, testbench, and memory material must be confirmed before a public release.
- The FPGA constraint file is included for public-preview reconstruction convenience, but its source and redistribution status still require human confirmation before a formal release.

## Roadmap

See `docs/roadmap.md`.

## Contributing

Contributions should include clear verification evidence and must not target fixed test programs with hard-coded behavior. See `CONTRIBUTING.md`.

## License

The repository uses the MIT License for files confirmed as original project work. Contest-provided materials, generated Vivado files, memory initialization programs, and third-party code are excluded unless redistribution rights are confirmed.

See `THIRD_PARTY_NOTICES.md` for current licensing cautions and files requiring human confirmation.
