# v0.1.0-preview Release Notes

This is a public preview release, not a stable formal release.

## Highlights

- Clean public repository layout for a JYD-style RV32I FPGA CPU/SoC project.
- Vivado project reconstruction flow.
- Public self-generated smoke memory test.
- Public branch-directed memory test.
- Public load/store-directed memory test.
- Private-memory XSim verification record showing contest-style RV32I 37/37 display.
- Repository Hygiene GitHub Actions workflow.
- Memory map documentation.
- Verification templates and public preview notes.

## Verification status

Public verification records currently include:

- Public smoke memory XSim verification.
- Public branch-directed XSim verification.
- Public load/store-directed XSim verification.

A private-memory RV32I 37/37 verification record is included, but the private
memory images are not redistributed.

## Known limitations

- This is not an official JYD repository.
- This is not a stable release.
- Public memory images do not claim RV32I 37/37 coverage.
- Private contest memory files are not included.
- XDC source and redistribution status still require human confirmation.
- Vivado XCI redistribution status still requires human confirmation.
- No official public performance benchmark result is claimed.
- No bitstream or Vivado generated outputs are included.

## Recommended users

- Students learning RV32I CPU/SoC design.
- FPGA beginners studying Vivado project reconstruction.
- Contributors interested in adding public directed tests and verification documentation.

## Do not claim

- Full RV32I compliance.
- Full RV32I 37/37 public reproduction.
- Production readiness.
- Benchmark leadership.
- Official contest endorsement.
