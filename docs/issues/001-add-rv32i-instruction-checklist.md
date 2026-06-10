# Title

Add an RV32I instruction checklist

## Background

The repository documents that the contest instruction test covers 37 RV32I instructions, but it does not yet provide a concise checklist mapping each instruction to RTL support notes and verification status.

## Expected Work

- Create a checklist document under `docs/`.
- List the 37 contest-tested RV32I instructions.
- Add columns for RTL location, directed-test status, and verification evidence.
- Mark unknown items as not yet verified instead of assuming support.

## Acceptance Criteria

- The checklist is readable in Markdown.
- No pass/fail result is claimed without evidence.
- `fence`, `ebreak`, and `ecall` are clearly marked as not contest-tested.
- No memory image files are required.

## Difficulty

Good first issue.

## Files Likely Involved

- `docs/`
- `rtl/core/Control.sv`
- `rtl/pipeline/IDU.sv`
- `rtl/core/ALU.sv`
