# Architecture

This document is based on the copied RTL. Statements that need deeper review are marked as待确认.

## Top-Level Structure

- `rtl/soc/top.sv` is the FPGA-facing top module. It instantiates `pll`, `uart`, and `twin_controller`.
- `rtl/soc/student_top.sv` bridges the contest-style CPU/SoC design. It instantiates `myCPU`, `IROM`, and `perip_bridge`.
- `rtl/core/myCPU.sv` is the CPU top-level module. It exposes IROM and peripheral interfaces.

Vivado project top: `top`.

## CPU Pipeline

`myCPU.sv` instantiates the following stages and registers:

- `IFU`
- `IF_ID_Reg`
- `IDU`
- `IFID_EX_Reg`
- `EXU`
- `EX_LSWB_Reg`
- `LSU`
- `WBU`

This indicates a pipelined design. The exact cycle behavior, stall policy, and forwarding paths need further verification against simulation traces.

## Stage Summary

- `IFU`: instruction fetch and PC output. It drives `irom_addr` through `IFU_pc`.
- `IDU`: instruction decode, immediate/control extraction, register read, CSR interaction, branch/jump decode.
- `EXU`: ALU execution and branch/jump result handling.
- `LSU`: load/store path. It drives `perip_addr`, `perip_wen`, `perip_wdata`, and `perip_mask`.
- `WBU`: write-back selection for register and CSR results.

## Core Support Modules

- `ALU`: arithmetic and logical operations.
- `Control`: pipeline control, next-PC handling, stalls/flushes, and forwarding-related signals.
- `CSR`: CSR storage and access logic.
- `RegisterFile`: integer register file.
- `Reg`, `Reg_Stack`, `MuxKey`, `MuxKeyInternal`, `sext`, `add`, `para`: shared helper modules.

## Hazards and Branch Prediction

- `Branch_Predictor.sv` exists and is instantiated in `myCPU.sv`.
- `Data_hazard.sv` exists in the RTL tree.
- `Control.sv` connects signals named `IFU_stall`, `IF_ID_stall`, `IF_ID_flush`, `EXU_inst_clear`, and forwarding-style inputs.

Detailed correctness of branch prediction update, mispredict recovery, flush, and data hazard behavior is待确认. Do not claim full hazard coverage until directed tests and traces are added.

## SoC and Peripherals

### `perip_bridge`

`perip_bridge.sv` decodes DRAM and memory-mapped peripherals:

- DRAM: `0x8010_0000` to `0x8013_FFFF`
- SW: `0x8020_0000`, `0x8020_0004`
- KEY: `0x8020_0010`
- SEG: `0x8020_0020`
- LED: `0x8020_0040`
- Counter: `0x8020_0050`

It instantiates `dram_driver`, `display_seg`, and `counter`.

### `dram_driver`

`dram_driver.sv` adapts CPU peripheral accesses to the DRAM IP. It handles byte/halfword/word write masks. Exact read-modify-write behavior should be verified with load/store directed tests.

### `counter`

`counter.sv` implements a counter with clock-domain crossing comments and Gray-code synchronization. Start/stop command behavior should be reviewed against `perip_bridge.sv` and contest requirements.

### Display

- `display_seg.sv` formats the display value.
- `seg7.sv` maps a digit to seven-segment output.

### UART and Twin Controller

- `uart.sv` implements serial receive/transmit logic.
- `twin_controller.sv` maps UART data to virtual switch/key inputs and returns SEG/KEY/SW/LED state buffers.

The UART protocol details and host-side tooling are待确认.

## Clock and Reset

`top.sv` instantiates a PLL. The original Vivado project used part `xc7k325tffg900-2` and `top` as synthesis top. Default contest CPU clock is expected to be 50 MHz, but the effective PLL output frequency must be confirmed in Vivado IP settings.

