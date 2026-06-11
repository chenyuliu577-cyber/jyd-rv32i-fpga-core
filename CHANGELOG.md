# Changelog

## v0.1.0-preview

Public preview milestone for the cleaned RV32I FPGA CPU/SoC repository. This is
not a stable release.

### Added

- Clean public repository layout and repository hygiene policy.
- Vivado project reconstruction flow.
- Public self-generated smoke memory flow and XSim verification record.
- Public branch-directed memory flow and XSim verification record.
- Public load/store-directed memory flow and XSim verification record.
- Repository Hygiene GitHub Actions workflow.
- Memory map documentation.
- Verification templates, public preview notes, and release readiness notes.

### Documented limitations

- Public memory images do not claim RV32I 37/37 coverage.
- Private contest memory files are not redistributed.
- XDC source and redistribution status still require human confirmation.
- Vivado XCI redistribution and Tcl-only IP regeneration status still require human confirmation.
- No official public performance benchmark result is claimed.
- This preview is not production-ready and is not an official contest release.

## Unreleased

- Created a clean open-source repository layout.
- Copied whitelisted RTL, testbench, XDC, and XCI files without changing RTL logic.
- Excluded Vivado generated directories, logs, bitstreams, checkpoints, reports, waveforms, crash dumps, and memory initialization files.
- Added documentation, hygiene script, GitHub templates, and Vivado reconstruction Tcl.
