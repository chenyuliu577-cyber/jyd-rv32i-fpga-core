# Vivado Workflow

## Recommended Project Entry

Use:

```tcl
source fpga/vivado/create_project.tcl
```

The script uses paths relative to the repository root. It does not depend on the original working directory.

Run it from a Vivado Tcl shell or with a Vivado command-line installation available in PATH. A plain PowerShell session without Vivado cannot execute the project creation flow.

The script creates local build output under `build/vivado`. This directory is ignored by `.gitignore`; remove it before running the clean repository check if generated logs or build products remain on disk.

Vivado may warn when the repository is checked out under a long Windows path. If IP or file lookup issues appear, use a shorter checkout path or a drive mapping.

## Files Added by the Script

- RTL from `rtl/`.
- Testbench files from `tb/`.
- Constraints from `fpga/constraints/digital_twin.xdc`.
- XCI files from `fpga/ip/`.

## Top Modules

- Synthesis top: `top`.
- Simulation top: `tb_top`.

## IP and Memory Files

The checked-in XCI files are copied from the working project after checking for local path strings. They may still require manual validation in a fresh Vivado environment.

The repository does not include memory initialization files. Add authorized memory files under `mem/`, then update the IROM and DRAM IP configuration in Vivado as needed.

When memory files are absent, Vivado 2023.2 may report skipped external `irom.coe` and `dram.coe` files during IROM/DRAM import. This is expected for the public cleanup and should be resolved only by adding authorized memory files or documenting a memory-generation workflow.

If imported XCI files do not regenerate cleanly, replace the import step with explicit IP creation Tcl and document all parameters.

The default reconstruction script imports only the IPs that are instantiated by the copied RTL:

- `IROM`
- `DRAM`
- `pll`

The repository also keeps `pll_1`, `counter_0`, and `counter_1` XCI files for audit and future review. They are not imported by default because the current RTL search found no instantiation of those IP module names. In Vivado 2023.2, `pll_1/pll.xci` conflicts with the existing IP name `pll`, and `counter_0`/`counter_1` reference a custom `counter (1.0)` IP definition that is not available in the standard Vivado catalog.

## PLL

The original project used a PLL IP and FPGA part `xc7k325tffg900-2`. The contest default CPU clock is 50 MHz, but the effective clock should be confirmed from the PLL IP settings before publishing timing or performance claims.

## Synthesis, Implementation, Bitstream

Generated synthesis, implementation, and bitstream outputs are local build artifacts. They should remain under a build directory or Vivado-generated directories and must not be committed.

Do not commit:

- `.Xil/`
- `*.runs/`
- `*.cache/`
- `*.gen/`
- `*.hw/`
- `*.ip_user_files/`
- `*.dcp`
- `*.bit`
- `*.rpt`
- `*.rpx`
- `*.log`
- `*.jou`

## Windows Path Hygiene

Avoid committing files that contain local absolute paths, user names, or machine names. Run `scripts/check_clean_repo.ps1` before staging files.
