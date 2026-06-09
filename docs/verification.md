# Verification

This repository does not yet include a reproducible verification report. The plan below defines how verification evidence should be collected.

## RV32I 37-Instruction Verification

A valid instruction-test report should include:

- The exact IROM/DRAM initialization files used.
- Vivado version and simulation or board environment.
- A run log or screenshot showing the pass count.
- SEG output showing 37 passed instructions.
- Any LED or UART status used by the test program.

Do not record 37/37 as a project result until the evidence is checked into `docs/` or attached to a release.

## Judging 37/37

The contest display rule uses the left two seven-segment digits for the RV32I pass count. A 37/37 result should be supported by:

- SEG value decoded as `37` for the instruction-test field.
- No hidden testbench forcing of pass status.
- No RTL special-casing of fixed IROM contents.

## Performance Test Correctness

Performance-test verification should include:

- The test program source or authorized binary description.
- Expected computation result.
- LED output pattern.
- Counter start and stop behavior.
- SEG timing display in milliseconds.

If only a temporary public test was used, label the result as a temporary run, not final performance.

## Current Testbench Coverage

Current files:

- `tb/tb_myCPU.sv`
- `tb/tb_top.sv`
- `tb/tb_uart.sv`

Observed scope:

- `tb_top.sv` instantiates `top` and observes `virtual_led`, `virtual_seg`, and internal CPU hierarchy signals.
- `tb_myCPU.sv` instantiates `top`.
- `tb_uart.sv` sends a byte to the UART module.

Coverage is limited. It should not be described as full verification.

## Uncovered Risks

- Branch and jump corner cases.
- Load/store byte and halfword sign/zero extension.
- Misaligned accesses, if any are expected by the contest.
- CSR, `ecall`, `ebreak`, and `fence` behavior.
- Pipeline stalls, flushes, and forwarding under back-to-back dependencies.
- DRAM read-modify-write behavior.
- Counter start/stop and clock-domain crossing behavior.
- UART protocol handling beyond a simple byte transaction.

## Directed Test Plan

- Arithmetic immediate and register operations.
- Branch taken/not-taken matrix.
- `jal` and `jalr` link and target behavior.
- Load/store byte, halfword, and word tests.
- Signed and unsigned comparison tests.
- Shift edge cases.
- Dependency chains across pipeline stages.
- Counter MMIO read/write test.

## Random Test Plan

- Random instruction streams constrained to supported RV32I instructions.
- Random register dependency sequences.
- Random DRAM byte/halfword/word access sequences.
- Random branch target alignment tests.

Random tests should use a reference model or signature comparison. A random run without an oracle is not meaningful verification.

