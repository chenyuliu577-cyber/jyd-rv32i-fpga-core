# Public Load/Store Directed Test

This directory contains the source description for a public, self-generated
RV32I load/store directed memory image.

The test is intentionally narrow. It covers basic aligned byte, halfword, and
word memory behavior, including signed and unsigned load extension. It does not
claim complete RV32I 37/37 verification, exception handling coverage, or
misaligned-access coverage.

Expected markers:

- Success SEG raw value: `0x0000C0DE`
- Failure SEG raw value: `0x0000BAD0`
- Success LED raw value: `0x00000001`
- Failure LED raw value: `0x000000EE`

Regenerate the memory images with:

```powershell
python tools/gen_load_store_directed_memory.py
```

Select this memory profile explicitly when reconstructing the Vivado project:

```powershell
$env:JYD_MEMORY_PROFILE = "load-store"
vivado -mode batch -source fpga/vivado/create_project.tcl
```
