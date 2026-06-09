# Optional Vivado IP Configurations

This directory keeps copied XCI files that are not part of the default public
project reconstruction flow.

The default Vivado entry point imports only:

- `fpga/ip/IROM/IROM.xci`
- `fpga/ip/DRAM/DRAM.xci`
- `fpga/ip/pll/pll.xci`

The XCI files under this directory are retained for audit and future review:

- `pll_1/pll.xci`
- `counter_0/counter_0.xci`
- `counter_1/counter_1.xci`

They are not imported by default because:

- `pll_1` uses an IP name that conflicts with the default `pll` IP.
- `counter_0` and `counter_1` reference a custom `counter (1.0)` IP definition
  that is not available in the standard Vivado catalog.
- The current public reconstruction flow is intentionally limited to IROM,
  DRAM, and pll.

If these IPs are later confirmed to be required, add the missing IP repository
or replace the copied XCI dependency with explicit Tcl IP-generation steps.
