# Public Preview Notes

This repository is ready for a public preview, not a formal stable release.

- Clean repository reconstruction has been tested with Vivado 2023.2.
- XSim private-memory verification observed `seg_wdata = 32'h37000000`.
- Public smoke memory images are included under `tests/public-memory/`.
- Private contest memory initialization files are private and not included.
- Users may provide their own authorized private `mem/irom.coe` and `mem/dram.coe`.
- Official contest memory files are not redistributed.
- Licensing of XDC/XCI/testbench/template-origin files still requires confirmation.
- Lightweight repository hygiene CI is included.
- No public performance number is claimed yet.
- No Codex for Open Source application should be submitted yet.

This preview is intended to let readers inspect the cleaned RTL, Vivado
reconstruction flow, documentation, and private-memory verification summary.
It must not be described as a stable release or as a complete public 37/37
reproduction package until memory-image licensing and public reproducibility
boundaries are confirmed.

## Public Smoke Memory

The public preview includes a self-generated RV32I smoke memory flow. The
generated memory images under `tests/public-memory/` come from
`tools/gen_public_smoke_memory.py` and repository-owned source, not from
contest-private memory files.

The smoke program writes raw SEG value `0x00000037` to address `0x8020_0020`.
That value is a smoke-test marker only and is not a public RV32I 37/37 result.

## Performance Status

The public preview includes performance documentation and a performance
verification template, but it does not claim an official public performance
benchmark result.

## CI Status

The public preview includes a lightweight repository hygiene workflow. It checks repository cleanliness and whitespace issues only. It does not run Vivado, XSim, FPGA implementation, bitstream generation, or RV32I correctness verification.
