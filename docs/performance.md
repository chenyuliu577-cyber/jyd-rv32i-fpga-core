# Performance

No official public performance benchmark result is claimed yet.

## Counter Mechanism

The performance counter MMIO address is `0x8020_0050`.

The documented command values are:

- Start command: write `0x8000_0000` to `0x8020_0050`.
- Stop command: write `0xFFFF_FFFF` to `0x8020_0050`.

Any performance record should state how these commands were observed, such as
an RTL signal, testbench display, SEG output, board display, or another clearly
described method.

## SEG Timing

Contest-style performance output may be shown on the seven-segment display in
milliseconds. A performance record must distinguish between raw SEG data and an
interpreted time value.

If a result is collected from simulation, label it as simulation. If a result is
collected from a physical FPGA board, label it as a board run. Do not present a
simulation observation as a board timing result.

## Evidence Policy

Every performance number must include:

- Commit hash.
- Vivado version.
- OS.
- Board or simulation environment.
- Clock frequency or clock source.
- Memory image source.
- Whether private memory files were used.
- Counter start/stop evidence.
- SEG and LED observations.
- Computation-result correctness evidence, if the benchmark includes a
  computation result.

Private memory files must not be committed. Complete Vivado logs, XSim logs,
waveforms, WDB files, bitstreams, DCP checkpoints, and generated Vivado outputs
should not be committed unless explicitly approved and reviewed for privacy and
redistribution concerns.

Use `docs/performance-verification-template.md` for future performance records.

## Current Repository Status

- Public smoke memory verifies a minimal public CPU/MMIO path. It is not a
  performance benchmark.
- Private-memory RV32I 37/37 verification exists separately and does not provide
  an official public performance benchmark result.
- No public full performance result is claimed yet.

## What Not to Claim

Do not claim:

- benchmark leadership
- a stable contest performance score
- a public full performance result without a verification record
- board timing from a simulation-only observation
- full RV32I correctness from the public smoke memory test
