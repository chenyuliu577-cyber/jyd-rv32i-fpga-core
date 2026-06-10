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
- Default IROM/DRAM XCI files from `fpga/ip/`.
- Default PLL XCI from `fpga/ip-optional/pll_1/pll.xci`.

## Top Modules

- Synthesis top: `top`.
- Simulation top: `tb_top`.

## IP and Memory Files

The checked-in XCI files are copied from the working project after checking for local path strings. They may still require manual validation in a fresh Vivado environment.

The repository does not include memory initialization files. Add authorized private memory files only under `mem/`:

- `mem/irom.coe`
- `mem/dram.coe`
- `mem/IROM.mif`
- `mem/DRAM.mif`

Do not place private memory files under `fpga/imports/test_src/`, and do not commit `.coe` or `.mif` files.

When memory files are absent, the reconstruction script reports this as the expected public-repository state. When `mem/irom.coe` and `mem/dram.coe` are present, it reports that local private memory files were found and attempts to bind IROM/DRAM `CONFIG.coefficient_file` to those paths. Confirm the IP paths in Vivado before publishing verification claims.

If imported XCI files do not regenerate cleanly, replace the import step with explicit IP creation Tcl and document all parameters.

The default reconstruction script imports only the IPs that are instantiated by the copied RTL:

- `IROM`
- `DRAM`
- `pll`

The default PLL source is `fpga/ip-optional/pll_1/pll.xci`. It still creates an IP named `pll`, but it has two clock outputs:

- `clk_out1`: 50 MHz
- `clk_out2`: 80 MHz

This matches `rtl/soc/top.sv`, which connects `clk_out1`, `clk_out2`, and `locked`. The one-output `fpga/ip/pll/pll.xci` is retained for audit but is not imported by default because it does not provide the `clk_out2` port used by the top-level RTL.

The repository also keeps `counter_0` and `counter_1` XCI files under `fpga/ip-optional/` for audit and future review. They are not imported by default because `counter_0`/`counter_1` reference a custom `counter (1.0)` IP definition that is not available in the standard Vivado catalog.

## PLL

The original project used a PLL IP and FPGA part `xc7k325tffg900-2`. The current default reconstruction uses the two-output PLL configuration copied from the working project:

- input: 200 MHz differential clock
- `clk_out1`: 50 MHz
- `clk_out2`: 80 MHz

Do not publish timing or performance claims without a matching timing or board record.

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
