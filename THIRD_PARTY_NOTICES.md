# Third-Party Notices and Licensing Cautions

This repository uses the MIT License for files confirmed as original project work. Some file categories still require human confirmation before a public release.

## Vivado IP configuration files

The repository includes selected Vivado `.xci` configuration files for
public-preview project reconstruction.

Current default IP configuration files:

- `fpga/ip/IROM/IROM.xci`
- `fpga/ip/DRAM/DRAM.xci`
- `fpga/ip-optional/pll_1/pll.xci`

Current default IP catalog references:

- IROM: `xilinx.com:ip:dist_mem_gen:8.0`, configured as `IROM`.
- DRAM: `xilinx.com:ip:dist_mem_gen:8.0`, configured as `DRAM`.
- PLL: `xilinx.com:ip:clk_wiz:6.0`, configured as `pll`.

Current status:

- Source/origin: pending human confirmation.
- Redistribution status: pending human confirmation.
- Public preview use: included to allow project reconstruction in Vivado.
- Formal release status: release-blocking until the maintainer confirms that
  the checked-in XCI files may be redistributed or replaces them with a
  Tcl-only IP generation flow.

The checked files use relative paths for generated output directories and do
not contain obvious local absolute paths, Windows user directories, user names,
or machine identifiers. The IROM/DRAM XCI files still include relative legacy
coefficient paths under `../../imports/test_src/`; the project reconstruction
script overrides memory initialization with private `mem/` files or public
smoke memory under `tests/public-memory/`.

The repository intentionally excludes generated Vivado IP output products such
as simulation netlists, synthesized checkpoints, implementation files, `.dcp`,
`.bit`, `.wdb`, `.rpt`, and generated cache directories.

Optional or non-default IP configuration files are not part of the default
reconstruction flow. `fpga/ip/pll/pll.xci` is retained for audit/reference but
is not imported by default because it does not match the current two-output
`pll` instantiation in `rtl/soc/top.sv`. `fpga/ip-optional/counter_0/` and
`fpga/ip-optional/counter_1/` reference `xilinx.com:user:counter:1.0`, which is
not a standard Vivado catalog IP in this repository. These files are retained
only for audit/reference until their necessity and redistribution status are
confirmed.

## Contest Material Note

This repository is an independent educational cleanup of a contest-oriented project. It is not an official JYD repository unless explicitly stated.

Any contest-provided templates, specifications, programs, or board files must be reviewed before redistribution. Documentation in this repository summarizes requirements conservatively and should not be treated as a replacement for the official contest PDF.

## FPGA constraints

The repository includes `fpga/constraints/digital_twin.xdc` for FPGA pin and
timing constraints.

Current status:

- Source/origin: pending human confirmation.
- Redistribution status: pending human confirmation.
- Public preview use: included for project reconstruction convenience.
- Formal release status: release-blocking until the file origin and
  redistribution permission are confirmed.

The current file does not contain an explicit copyright, license, source,
vendor, contest, course, generated-file, proprietary, or confidential notice.
It also does not contain an obvious local path, user name, or machine
identifier. This absence is not proof of redistribution permission.

Before a formal release, the maintainer should confirm whether this file is
original project work, derived from a board vendor template, contest/course
material, or another third-party source.

## Memory Initialization Material Note

Memory initialization materials are excluded by default, including:

- `IROM.mif`
- `DRAM.mif`
- `irom.coe`
- `dram.coe`

These files may contain contest test programs or other material with unclear redistribution rights. Add them only after authorization is confirmed.

## Files Requiring Human Confirmation

- `fpga/constraints/digital_twin.xdc`
- `fpga/ip/**/*.xci`
- `fpga/ip-optional/**/*.xci`
- `tb/*.sv`
- `rtl/common/MuxKey.v`
- `rtl/common/MuxKeyInternal.v`
- Any future memory initialization files
- Any future files copied from contest templates, course material, vendor examples, or third-party repositories

## Excluded Generated Outputs

The following generated outputs are intentionally excluded:

- Vivado generated directories
- XSim output directories
- Logs and journals
- DCP checkpoints
- Bitstreams
- Reports
- Waveforms
- Crash dumps
- Large intermediate build files
