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

With private `mem/irom.coe` and `mem/dram.coe` files present, the current
private-memory XSim flow has reached compile, elaboration, and simulation. The
observed internal SEG write data was `32'h37000000`, interpreted as the RV32I
37/37 display. This result depends on private memory images that are not
included in Git.

## Memory Initialization

The cleanup excludes private memory initialization files. Add authorized files only under `mem/`:

- `mem/irom.coe`
- `mem/dram.coe`
- `mem/IROM.mif`
- `mem/DRAM.mif`

Before running tests that depend on program memory, recreate the Vivado project and confirm that the IROM/DRAM IP configuration uses the local files under `mem/`. The Tcl flow attempts to bind `CONFIG.coefficient_file` automatically when `mem/irom.coe` and `mem/dram.coe` are present. Do not commit `.coe` or `.mif` files.

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
