# Title

Fix testbench comment encoding without changing logic

## Background

Some inherited testbench comments appear to have encoding artifacts. Cleaning comments would improve readability.

## Expected Work

- Review `tb/*.sv` for garbled comments.
- Replace comments with clear English or Chinese text encoded consistently.
- Do not change executable SystemVerilog statements.

## Acceptance Criteria

- Only comments and whitespace are changed.
- Testbench logic is unchanged.
- A diff review can clearly confirm no behavioral changes.
- No generated simulation files are committed.

## Difficulty

Good first issue.

## Files Likely Involved

- `tb/tb_myCPU.sv`
- `tb/tb_top.sv`
- `tb/tb_uart.sv`

