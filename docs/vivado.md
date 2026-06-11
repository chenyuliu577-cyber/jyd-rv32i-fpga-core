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

## Vivado IP Handling

The default reconstruction script imports only the IPs required by the copied
RTL:

- `fpga/ip/IROM/IROM.xci`: Xilinx `dist_mem_gen:8.0`, configured as `IROM`.
- `fpga/ip/DRAM/DRAM.xci`: Xilinx `dist_mem_gen:8.0`, configured as `DRAM`.
- `fpga/ip-optional/pll_1/pll.xci`: Xilinx `clk_wiz:6.0`, configured as
  `pll`.

The default PLL source is `fpga/ip-optional/pll_1/pll.xci` because it provides
`clk_out1`, `clk_out2`, and `locked`, matching the `pll` instance in
`rtl/soc/top.sv`. The non-default `fpga/ip/pll/pll.xci` is retained for
audit/reference but is not imported by default because it does not provide the
same two-output interface.

The optional `counter_0` and `counter_1` XCI files are not imported by default.
They reference `xilinx.com:user:counter:1.0`, a custom IP definition that is
not included in this repository and is not part of the standard Vivado catalog
used by the default flow.

The default flow has imported the selected IROM, DRAM, and PLL XCI files in
Vivado 2023.2 during local public-preview checks. This does not settle their
redistribution status. If these XCI files cannot be redistributed or do not
import cleanly in a future environment, the preferred follow-up is to replace
checked-in XCI dependency with a Tcl-only IP regeneration path and document all
parameters.

## IP and Memory Files

The checked-in XCI files are copied from the working project after checking for local path strings. They may still require manual validation in a fresh Vivado environment.

The repository includes public self-generated smoke memory under
`tests/public-memory/`. These files are generated from
`tools/gen_public_smoke_memory.py` and are not derived from contest-private
memory files.

Private contest memory files remain excluded. Add authorized private memory
files only under `mem/`:

- `mem/irom.coe`
- `mem/dram.coe`
- `mem/IROM.mif`
- `mem/DRAM.mif`

Do not place private memory files under `fpga/imports/test_src/`, and do not
commit private `.coe` or `.mif` files under `mem/`.

The reconstruction script selects memory in this order:

1. `mem/irom.coe` and `mem/dram.coe` private local files.
2. `tests/public-memory/irom.coe` and `tests/public-memory/dram.coe` public
   smoke files.
3. No memory files, with a warning that simulation may not run meaningful CPU
   code.

Set `JYD_MEMORY_PROFILE=branch` to explicitly select
`tests/branch-memory/irom.coe` and `tests/branch-memory/dram.coe` when private
memory files are absent. Branch directed memory is not the default public
profile.

Set `JYD_MEMORY_PROFILE=load-store` to explicitly select
`tests/load-store-memory/irom.coe` and `tests/load-store-memory/dram.coe` when
private memory files are absent. Load/store directed memory is not the default
public profile.

Confirm the IROM/DRAM `CONFIG.coefficient_file` paths in Vivado before
publishing verification claims.

The public smoke program writes raw SEG value `0x00000037` to MMIO address
`0x8020_0020`. This is only a smoke marker and is not RV32I 37/37 verification.

The public load/store directed program writes raw SEG value `0x0000C0DE` on
success and `0x0000BAD0` on failure. This is only a directed load/store marker
and is not RV32I 37/37 verification.

If imported XCI files do not regenerate cleanly, replace the import step with explicit IP creation Tcl and document all parameters.

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
- `*.wdb`
- `*.rpt`
- `*.rpx`
- `*.log`
- `*.jou`

## Windows Path Hygiene

Avoid committing files that contain local absolute paths, user names, or machine names. Run `scripts/check_clean_repo.ps1` before staging files.
