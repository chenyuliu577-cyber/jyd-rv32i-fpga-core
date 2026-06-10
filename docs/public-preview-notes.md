# Public Preview Notes

This repository is ready for a public preview, not a formal stable release.

- Clean repository reconstruction has been tested with Vivado 2023.2.
- XSim private-memory verification observed `seg_wdata = 32'h37000000`.
- Memory initialization files are private and not included.
- Users must provide their own `mem/irom.coe` and `mem/dram.coe`.
- Official contest memory files are not redistributed.
- Licensing of XDC/XCI/testbench/template-origin files still requires confirmation.
- No CI is included yet.
- No public performance number is claimed yet.
- No Codex for Open Source application should be submitted yet.

This preview is intended to let readers inspect the cleaned RTL, Vivado
reconstruction flow, documentation, and private-memory verification summary.
It must not be described as a stable release or as a complete public 37/37
reproduction package until memory-image licensing and public reproducibility
boundaries are confirmed.
