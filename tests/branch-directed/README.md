# Public RV32I Branch Directed Test

This directory contains a repository-owned directed branch test source. It is
not derived from contest-private memory files and does not require a RISC-V
compiler toolchain.

The generated program covers these branch cases:

- BEQ taken
- BEQ not taken
- BNE taken
- BNE not taken
- BLT signed taken
- BGE signed taken
- BLTU unsigned taken
- BGEU unsigned taken
- JAL final self-loop

The test accumulates a score as each directed branch case reaches its expected
path. Any unexpected branch behavior jumps to a failure path.

Expected markers:

- Success SEG raw value: `0x0000BEEF`
- Failure SEG raw value: `0x0000BAD0`
- Success LED raw value: `0x00000001`
- Failure LED raw value: `0x000000EE`

This is a directed branch smoke test. It is not complete RV32I verification and
does not claim RV32I 37/37 coverage.

Regenerate the branch memory images with:

```powershell
python tools/gen_branch_directed_memory.py
```

Run the Vivado reconstruction with branch memory by setting:

```powershell
$env:JYD_MEMORY_PROFILE = "branch"
vivado -mode batch -source fpga/vivado/create_project.tcl
```
