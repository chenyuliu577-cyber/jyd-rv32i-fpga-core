# Public Branch Directed Memory Images

This directory contains public, repository-owned branch-directed memory images
generated from `tools/gen_branch_directed_memory.py` and documented by
`tests/branch-directed/rv32i_branch_directed.S`.

These files are intentionally tracked:

- `irom.coe`: public RV32I branch-directed instruction memory.
- `dram.coe`: zero-initialized public data memory for the current DRAM IP depth.

The images do not contain contest-private memory content. They only support a
directed public branch test and do not claim RV32I 37/37 correctness.

Regenerate them with:

```powershell
python tools/gen_branch_directed_memory.py
```

This memory is not the default public memory profile. Use it explicitly:

```powershell
$env:JYD_MEMORY_PROFILE = "branch"
vivado -mode batch -source fpga/vivado/create_project.tcl
```

Expected markers:

- Success SEG raw value: `0x0000BEEF`
- Failure SEG raw value: `0x0000BAD0`
