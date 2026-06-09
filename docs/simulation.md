# Simulation

This repository is organized for Vivado XSim simulation.

## Testbenches

- `tb/tb_myCPU.sv`: CPU/top wrapper-oriented testbench.
- `tb/tb_top.sv`: top-level testbench observing virtual LED and SEG outputs.
- `tb/tb_uart.sv`: UART module testbench.

## XSim Flow

1. Recreate the Vivado project:

```tcl
source fpga/vivado/create_project.tcl
```

2. Confirm simulation top:

```tcl
set_property top tb_top [get_filesets sim_1]
update_compile_order -fileset sim_1
```

3. Run behavioral simulation from Vivado GUI or Tcl.

## Memory Initialization

The cleanup excludes `IROM.mif`, `DRAM.mif`, `irom.coe`, and `dram.coe`. Add authorized files under `mem/` and update the IROM/DRAM IP configuration before running tests that depend on program memory.

## Waveforms

Waveform files are generated artifacts and must not be committed. Use Vivado/XSim to add signals during local runs. If a waveform is needed for documentation, export a small screenshot and confirm it contains no private path or contest-private material.

## Logs

Simulation logs are local artifacts. Summarize important results in documentation instead of committing raw logs.

Do not commit:

- `*.log`
- `*.jou`
- `*.wdb`
- `*.wcfg`
- `xsim.dir/`
- `*.vcd`
- `*.fst`

