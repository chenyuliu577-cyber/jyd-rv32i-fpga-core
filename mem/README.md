# Memory Initialization Files

This repository does not include default memory initialization files.

Place your own files here when running simulation or rebuilding the Vivado
project:

- `irom.coe`
- `dram.coe`
- `IROM.mif`
- `DRAM.mif`

Use this directory as the single private memory-file location. Do not place
private memory files under `fpga/imports/test_src/`, and do not commit any
`.coe` or `.mif` files to Git.

The original working project contained memory files that may include contest
test programs or other material with unclear redistribution rights. They are
therefore excluded from the default open-source tree until manually reviewed.
