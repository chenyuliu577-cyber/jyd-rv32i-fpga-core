# Test Profiles and Memory Selection

This page summarizes the public test profiles and the private contest-memory
profile used by the Vivado reconstruction flow.

## Overview

| Profile | Memory path | Selection method | Expected SEG marker | Purpose | Limitations |
| --- | --- | --- | --- | --- | --- |
| Default public smoke | `tests/public-memory/` | Default public fallback when private `mem/` images are absent | `0x00000037` | Minimal public instruction/MMIO smoke path | Not RV32I 37/37 |
| Branch-directed | `tests/branch-memory/` | `$env:JYD_MEMORY_PROFILE="branch"` | `0x0000BEEF` | Basic BEQ/BNE/BLT/BGE/BLTU/BGEU directed behavior | Directed branch coverage only |
| Load/store-directed | `tests/load-store-memory/` | `$env:JYD_MEMORY_PROFILE="load-store"` | `0x0000C0DE` | Basic SW/LW, SH/LH/LHU, SB/LB/LBU behavior | Directed load/store coverage only |
| Private contest memory | `mem/irom.coe` and `mem/dram.coe` | Automatic highest priority when both private memory files exist | Private-memory 37/37 record exists | Contest-style private-memory verification | Private memory images are not redistributed |

## Selection Priority

If `mem/irom.coe` and `mem/dram.coe` exist, the Vivado reconstruction script
uses private memory first.

If private memory does not exist, the script uses `JYD_MEMORY_PROFILE` to select
a public profile. `JYD_MEMORY_PROFILE=branch` selects branch-directed memory,
and `JYD_MEMORY_PROFILE=load-store` selects load/store-directed memory.

If `JYD_MEMORY_PROFILE` is not set, the script uses public smoke memory under
`tests/public-memory/` by default.

Public tests are directed tests. They do not claim full RV32I compliance, public
RV32I 37/37 reproduction, or an official performance benchmark.

## PowerShell Examples

```powershell
# Default public smoke
Remove-Item Env:JYD_MEMORY_PROFILE -ErrorAction SilentlyContinue
vivado -mode batch -source fpga/vivado/create_project.tcl

# Branch-directed
$env:JYD_MEMORY_PROFILE="branch"
vivado -mode batch -source fpga/vivado/create_project.tcl

# Load/store-directed
$env:JYD_MEMORY_PROFILE="load-store"
vivado -mode batch -source fpga/vivado/create_project.tcl
```
