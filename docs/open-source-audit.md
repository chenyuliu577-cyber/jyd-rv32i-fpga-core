# Open Source Audit Summary

The original working directory contained a valid Vivado/SystemVerilog project mixed with generated output. This repository was created as a clean copy, not by deleting files from the original project.

## Copied

- Whitelisted RTL files from `digital_twin.srcs/sources_1/imports/new/`.
- Whitelisted RTL files from `digital_twin.srcs/sources_1/new/`.
- Testbench files from `digital_twin.srcs/sim_1/new/`.
- `digital_twin.xdc`.
- Selected XCI files after checking for local path strings.

## Excluded

- Vivado generated directories.
- Simulation output directories.
- Logs, journals, crash dumps, waveforms, bitstreams, checkpoints, reports, and large intermediate files.
- Memory initialization files pending authorization review.

## Authorization Pending

- XDC source and redistribution rights.
- XCI redistribution or replacement with Tcl IP generation.
- Testbench origin and license.
- Memory initialization files.
- Helper modules such as `MuxKey.v` and `MuxKeyInternal.v`.

## Current Public-Readiness Status

The repository is suitable for local cleanup review. It should not be described as mature or fully verified until public verification artifacts and licensing review are complete.
