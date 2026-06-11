# Verification

This repository includes a public self-generated smoke memory flow. It is a
minimal reproducible path, not a public RV32I 37/37 verification flow. The plan
below defines how verification evidence should be collected.

The current repository has a private-memory XSim verification record observing
the RV32I 37/37 display. This is not a public memory-image release; the memory
files remain private and ignored by Git.

## Public Smoke Memory Workflow

The public smoke memory is generated from repository-owned source and script:

- `tests/public-smoke/rv32i_smoke.S`
- `tools/gen_public_smoke_memory.py`
- `tests/public-memory/irom.coe`
- `tests/public-memory/dram.coe`

Regenerate it with:

```powershell
python tools/gen_public_smoke_memory.py
```

The expected public smoke marker is a raw write of `0x00000037` to SEG MMIO
address `0x8020_0020`. The smoke program also writes `0x00000001` to LED MMIO
address `0x8020_0040` and writes counter start/stop commands to
`0x8020_0050`.

This flow can show that a public instruction memory image can be generated,
loaded into the Vivado project, and used for a minimal CPU/MMIO path. It does
not cover all RV32I instructions and must not be described as 37/37
verification.

## Private Memory Verification Workflow

Private memory initialization files are allowed only for local verification and
must not be committed.

1. Place authorized local memory files under `mem/`:
   - `mem/irom.coe`
   - `mem/dram.coe`
   - or `mem/IROM.mif`
   - or `mem/DRAM.mif`
2. Recreate the Vivado project with `fpga/vivado/create_project.tcl`.
3. Manually or automatically confirm that the IROM and DRAM IP configuration
   uses the local files under `mem/`.
4. Run XSim or board verification.
5. Record:
   - Vivado version
   - commit hash
   - memory file source: private, contest-provided, or self-generated
   - confirmation that memory files were not committed
   - RV32I pass count
   - SEG display
   - LED display
   - performance counter result, if applicable
6. Commit only a verification summary. Do not commit unauthorized memory files,
   complete raw logs, bitstreams, or generated Vivado outputs.

Use `docs/verification-record-template.md` or a dated template under
`docs/verification-records/` when preparing evidence.

## RV32I 37-Instruction Verification

A valid instruction-test report should include:

- The exact IROM/DRAM initialization files used.
- Vivado version and simulation or board environment.
- A run log or screenshot showing the pass count.
- SEG output showing 37 passed instructions.
- Any LED or UART status used by the test program.

Do not record 37/37 as a public no-memory reproduction result until an
authorized redistributable memory image or equivalent public test flow exists.

## Judging 37/37

The contest display rule uses the left two seven-segment digits for the RV32I pass count. A 37/37 result should be supported by:

- SEG value decoded as `37` for the instruction-test field.
- No hidden testbench forcing of pass status.
- No RTL special-casing of fixed IROM contents.
- A clear statement about whether the result depends on private memory images.

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
