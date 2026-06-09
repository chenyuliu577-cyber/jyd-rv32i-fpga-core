# Third-Party Notices and Licensing Cautions

This repository uses the MIT License for files confirmed as original project work. Some file categories still require human confirmation before a public release.

## Vivado and Xilinx/AMD IP Note

The repository includes selected Vivado `.xci` IP configuration files under `fpga/ip/`. These are configuration files copied from the working project after checking for local path strings. Their redistribution status and long-term rebuild strategy must still be confirmed.

No generated Vivado simulation, synthesis, implementation, checkpoint, report, waveform, or bitstream outputs are included.

## Contest Material Note

This repository is an independent educational cleanup of a contest-oriented project. It is not an official JYD repository unless explicitly stated.

Any contest-provided templates, specifications, programs, or board files must be reviewed before redistribution. Documentation in this repository summarizes requirements conservatively and should not be treated as a replacement for the official contest PDF.

## Memory Initialization Material Note

Memory initialization materials are excluded by default, including:

- `IROM.mif`
- `DRAM.mif`
- `irom.coe`
- `dram.coe`

These files may contain contest test programs or other material with unclear redistribution rights. Add them only after authorization is confirmed.

## Files Requiring Human Confirmation

- `fpga/constraints/digital_twin.xdc`
- `fpga/ip/**/*.xci`
- `tb/*.sv`
- `rtl/common/MuxKey.v`
- `rtl/common/MuxKeyInternal.v`
- Any future memory initialization files
- Any future files copied from contest templates, course material, vendor examples, or third-party repositories

## Excluded Generated Outputs

The following generated outputs are intentionally excluded:

- Vivado generated directories
- XSim output directories
- Logs and journals
- DCP checkpoints
- Bitstreams
- Reports
- Waveforms
- Crash dumps
- Large intermediate build files

