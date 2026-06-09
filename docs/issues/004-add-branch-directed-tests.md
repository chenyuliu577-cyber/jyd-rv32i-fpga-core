# Title

Add directed tests for branch instructions

## Background

Branch behavior is central to CPU correctness and pipeline recovery. The repository has branch-related RTL and a branch predictor module, but public directed tests are not yet included.

## Expected Work

- Design small branch test cases for `beq`, `bne`, `blt`, `bge`, `bltu`, and `bgeu`.
- Provide source or testbench-level checks that do not depend on redistributing contest memory images.
- Document expected outcomes and how to run the tests.

## Acceptance Criteria

- Tests are reproducible without unauthorized memory images.
- Expected results are documented.
- No hard-coded pass behavior is added to RTL.
- No generated simulation outputs are committed.

## Difficulty

Intermediate.

## Files Likely Involved

- `tb/`
- `docs/verification.md`
- `rtl/pipeline/Branch_Predictor.sv`
- `rtl/core/Control.sv`

