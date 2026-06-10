# Performance

No reliable public performance number is included in this cleanup. Performance data is待补充.

## Counter Mechanism

The contest counter is mapped at `0x8020_0050` to `0x8020_0053`.

Contest request summary:

- Write `0x8000_0000` to start counting.
- Write `0xFFFF_FFFF` to stop counting.

The copied RTL shows `CNT_START_CMD = 32'h8000_0000` in `perip_bridge.sv`. The stop command requires review before documenting final behavior.

## Display

The contest display rule expects the right six seven-segment digits to show performance-test execution time in milliseconds. The left two digits show RV32I instruction-test pass count.

## Reporting Rules

Any future performance report must include:

- Vivado version.
- FPGA board and clock frequency.
- Exact memory initialization files.
- Whether the run was simulation or board execution.
- Counter start/stop evidence.
- SEG and LED observations.

Do not publish temporary test results as final performance. Do not optimize specifically for fixed IROM contents or a fixed benchmark while presenting it as a general optimization.
