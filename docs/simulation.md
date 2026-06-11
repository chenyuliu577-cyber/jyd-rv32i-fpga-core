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

With private memory absent, the Vivado reconstruction script falls back to the
public self-generated smoke memory under `tests/public-memory/`. The expected
public smoke observation is a raw write of `0x00000037` to SEG address
`0x8020_0020`, an optional raw write of `0x00000001` to LED address
`0x8020_0040`, and counter start/stop writes to `0x8020_0050`. The SEG value is
only a smoke marker; it is not an RV32I 37/37 result.

The public branch directed memory is available only when explicitly selected
with `JYD_MEMORY_PROFILE=branch`. Its expected success observation is a raw
write of `0x0000BEEF` to SEG address `0x8020_0020` and `0x00000001` to LED
address `0x8020_0040`. A failure path writes SEG raw value `0x0000BAD0` and LED
raw value `0x000000EE`. This directed test is not full RV32I verification.

## Memory Initialization

The cleanup excludes private contest memory initialization files. Add
authorized private files only under `mem/`:

- `mem/irom.coe`
- `mem/dram.coe`
- `mem/IROM.mif`
- `mem/DRAM.mif`

Before running private-memory tests, recreate the Vivado project and confirm
that the IROM/DRAM IP configuration uses the local files under `mem/`. The Tcl
flow attempts to bind `CONFIG.coefficient_file` automatically when
`mem/irom.coe` and `mem/dram.coe` are present. Do not commit private `.coe` or
`.mif` files.

To regenerate and test the public smoke memory:

```powershell
python tools/gen_public_smoke_memory.py
vivado -mode batch -source fpga/vivado/create_project.tcl
```

Then run `tb_top` in XSim and observe the SEG/LED/counter signals. Record the
result as public smoke verification only, not full RV32I verification.

To regenerate and test the public branch directed memory:

```powershell
python tools/gen_branch_directed_memory.py
$env:JYD_MEMORY_PROFILE = "branch"
vivado -mode batch -source fpga/vivado/create_project.tcl
```

Then run `tb_top` in XSim and observe the SEG/LED signals. Record the result as
branch directed verification only, not RV32I 37/37 verification.

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
