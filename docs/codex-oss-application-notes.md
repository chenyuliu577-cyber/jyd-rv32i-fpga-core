# Codex for Open Source Application Notes

This is an internal preparation document. It should not be used as marketing copy.

## Potential Open Source Value

- The project is a real Vivado/SystemVerilog RV32I FPGA CPU/SoC codebase.
- It can help students study digital design, computer organization, pipeline structure, memory-mapped peripherals, and FPGA project organization.
- It connects contest requirements with concrete RTL, testbenches, Vivado IP configuration, memory maps, and verification planning.
- The cleanup process improves reproducibility and makes the project safer to publish.

## Current Shortcomings

- The project is early-stage as an open-source repository.
- There are no public stars, users, releases, or external contributors to cite.
- CI has not been added.
- A public 37/37 verification report has not been added.
- Licensing of XDC, XCI, testbench, helper modules, and memory files still needs confirmation.

## 7-Day Maintenance Plan

- Run the clean-repository check before the first commit.
- Review all copied RTL for license/source notes.
- Add an instruction checklist.
- Add a memory map diagram.
- Add a first verification report template.
- Open good first issues for documentation and directed tests.

## 30-Day Maintenance Plan

- Publish a conservative v0.1.0 release after license review.
- Add directed RV32I tests.
- Add a Vivado project recreation verification note.
- Add syntax/lint checks if practical.
- Document board-level runs with screenshots or concise summaries.
- Review issues and PRs weekly.

## Good First Issue Plan

- Fix garbled comments in testbench without changing logic.
- Add RV32I instruction checklist.
- Add memory map diagram.
- Add XSim quickstart screenshots.
- Add directed branch tests.
- Add directed load/store byte and halfword tests.
- Add a Verilator compile experiment.
- Add a timing report template.

## Issue, PR, and Release Plan

- Use issue templates for bugs, features, and verification reports.
- Require PR authors to state whether RTL behavior changed.
- Reject generated Vivado output, bitstreams, logs, and local paths.
- Use releases only when documentation and verification artifacts match the actual repository state.

## Draft: Why does this repository qualify?

This repository is an early-stage open-source cleanup of a real RV32I FPGA CPU/SoC project built with SystemVerilog and Vivado for a JYD RISC-V contest setting. Its value is educational: it gives students a concrete codebase for studying RV32I execution, pipeline organization, memory-mapped peripherals, FPGA constraints, IP configuration, simulation, and verification planning. I am not claiming existing popularity, external users, or mature production quality. The goal is to publish a clean, reproducible, maintainable repository that can be useful for RISC-V and FPGA learning.

## Draft: How will you use API credits?

I would use API credits to improve maintainability and educational quality: reviewing RTL documentation, generating directed test plans, drafting issue triage summaries, checking PRs for accidental generated files or local paths, improving verification reports, and preparing release notes that accurately reflect the repository state. I would also use Codex to help create small testbenches and documentation updates while keeping claims conservative and evidence-based. The credits would support ongoing maintenance, not artificial popularity or benchmark claims.

## Draft: Anything else we should know?

This project is still early as an open-source repository. It may not yet have stars, releases, external users, or CI history. I am intentionally avoiding inflated claims and excluding memory programs or contest materials until redistribution rights are confirmed. The immediate plan is to publish a clean v0.1.0, add verification artifacts, create good first issues, document Vivado reconstruction, and maintain a transparent roadmap. The repository is meant to be a practical learning resource for RV32I and FPGA CPU design.

