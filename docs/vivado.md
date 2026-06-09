# Vivado Workflow

## Recommended Project Entry

Use:

```tcl
source fpga/vivado/create_project.tcl
```

The script uses paths relative to the repository root. It does not depend on the original working directory.

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

If imported XCI files do not regenerate cleanly, replace the import step with explicit IP creation Tcl and document all parameters.

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

