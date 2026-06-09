# Title

Add directed tests for load and store instructions

## Background

The DRAM path and write-mask handling need dedicated tests for byte, halfword, and word operations.

## Expected Work

- Add directed tests for `lb`, `lh`, `lw`, `lbu`, `lhu`, `sb`, `sh`, and `sw`.
- Cover sign extension, zero extension, and write-mask behavior.
- Avoid using memory images with unclear redistribution rights.

## Acceptance Criteria

- Tests document expected register or memory signatures.
- Tests can be regenerated or assembled from included source, or are implemented directly in a testbench.
- No fixed contest memory image is committed.
- No RTL special-casing is introduced.

## Difficulty

Intermediate.

## Files Likely Involved

- `tb/`
- `rtl/pipeline/LSU.sv`
- `rtl/soc/dram_driver.sv`
- `docs/verification.md`

