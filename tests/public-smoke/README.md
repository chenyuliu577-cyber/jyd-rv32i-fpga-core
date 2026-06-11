# Public RV32I Smoke Test

This directory contains a small repository-owned RV32I smoke test source. It is
not derived from contest-private memory files and does not require a RISC-V
compiler toolchain.

The generated program writes these MMIO values:

- `0x80000000` to counter address `0x80200050` to request counter start.
- `0x00000037` to SEG address `0x80200020` as a smoke-test magic value.
- `0x00000001` to LED address `0x80200040` as an optional visible marker.
- `0xffffffff` to counter address `0x80200050` to request counter stop.

The `0x00000037` SEG value is only a public smoke-test marker. It is not an
RV32I 37/37 instruction-test result and must not be described as full RV32I
correctness verification.

Regenerate the public memory images with:

```powershell
python tools/gen_public_smoke_memory.py
```
