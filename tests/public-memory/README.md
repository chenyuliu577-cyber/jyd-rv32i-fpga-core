# Public Smoke Memory Images

This directory contains public, repository-owned smoke-test memory images
generated from `tools/gen_public_smoke_memory.py` and documented by
`tests/public-smoke/rv32i_smoke.S`.

These files are intentionally tracked:

- `irom.coe`: public RV32I smoke-test instruction memory.
- `dram.coe`: zero-initialized public data memory for the current DRAM IP depth.

The images do not contain contest-private memory content. They only support a
minimal public smoke path and do not claim RV32I 37/37 correctness.

Regenerate them with:

```powershell
python tools/gen_public_smoke_memory.py
```

The expected smoke marker is a write of raw value `0x00000037` to SEG MMIO
address `0x80200020`. That value is not a 37/37 instruction-test result.
