# Getting Started

This guide is for first-time contributors and readers who are new to FPGA
projects, Vivado, or this repository.

## Repository Overview

This repository is an educational RV32I FPGA CPU/SoC project organized around a
JYD RISC-V contest-style memory map, Vivado project reconstruction flow, and
verification records.

The repository includes:

- SystemVerilog RTL under `rtl/`
- XSim-oriented testbenches under `tb/`
- Vivado reconstruction scripts under `fpga/vivado/`
- public self-generated memory tests under `tests/`
- documentation, release notes, and verification records under `docs/`

It is not an official JYD repository, not a stable release, and not a full
RV32I compliance claim.

## Intended Audience

This project may be useful for:

- students learning RV32I CPU and SoC structure
- FPGA beginners learning how a Vivado project can be reconstructed from source
- contributors interested in public directed tests and verification notes
- maintainers reviewing documentation, issue triage, and repository hygiene

You do not need private contest memory files to inspect the public test flows.

## Recommended Reading Order

Start with these files:

1. `README.md` for the high-level project status and quickstart.
2. `docs/memory-map.md` for the CPU-visible address map.
3. `docs/test-profiles.md` for public and private memory profile selection.
4. `docs/simulation.md` for XSim and memory initialization workflow.
5. `docs/verification.md` for what is verified and what is not verified.
6. `docs/public-preview-notes.md` for preview limitations.
7. `THIRD_PARTY_NOTICES.md` for licensing and redistribution cautions.

Read `docs/public-release-checklist.md` before making release-related claims.

## Public Verification Paths

The public verification paths use repository-owned generated memory images.

- Public smoke memory: `tests/public-memory/`
  - Generate with `python tools/gen_public_smoke_memory.py`
  - Expected SEG raw marker: `0x00000037`
  - Minimal public instruction/MMIO smoke path only

- Branch-directed memory: `tests/branch-memory/`
  - Generate with `python tools/gen_branch_directed_memory.py`
  - Select with `$env:JYD_MEMORY_PROFILE="branch"`
  - Expected SEG raw marker: `0x0000BEEF`
  - Directed branch coverage only

- Load/store-directed memory: `tests/load-store-memory/`
  - Generate with `python tools/gen_load_store_directed_memory.py`
  - Select with `$env:JYD_MEMORY_PROFILE="load-store"`
  - Expected SEG raw marker: `0x0000C0DE`
  - Directed load/store coverage only

These public tests do not claim public RV32I 37/37 reproduction or full RV32I
compliance.

## Private-Memory Verification Explanation

Private contest-style memory verification is documented separately in
`docs/verification-records/`.

The private-memory record shows that a private-memory XSim run observed the
contest-style RV32I 37/37 display. The private memory images are not included,
not redistributed, and should not be copied into Git.

If `mem/irom.coe` and `mem/dram.coe` exist locally, the Vivado reconstruction
flow uses them first. That behavior is intentional for private local
verification, but those files must remain untracked.

## Common Beginner Mistakes

- Do not commit `mem/irom.coe`, `mem/dram.coe`, or private `.mif` files.
- Do not commit Vivado generated directories, logs, waveforms, bitstreams, or checkpoints.
- Do not describe public smoke or directed tests as RV32I 37/37.
- Do not claim complete RV32I compliance from the current public tests.
- Do not create a release or tag unless the maintainer explicitly requests it.
- Do not treat XCI/XDC redistribution status as fully confirmed.
- Do not edit RTL when the task is documentation-only.

Run the repository hygiene check before committing:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/check_clean_repo.ps1
git diff --check
```

## How to Report Issues

When opening an issue, include:

- what you tried to do
- your OS and Vivado version
- the command you ran
- whether private `mem/` files were present
- the selected `JYD_MEMORY_PROFILE`, if any
- the observed SEG/LED value or error stage

Do not paste private memory contents or full generated Vivado logs into issues.
Short summaries are preferred.

## How to Contribute Documentation

Good documentation contributions include:

- clarifying setup steps for new users
- improving Vivado reconstruction notes
- linking related docs consistently
- documenting limitations without overstating results
- adding concise verification records or templates

Keep documentation changes scoped. If a documentation change does not require
RTL changes, leave RTL untouched.

## How to Contribute Tests

Public tests should be self-generated and reproducible from repository-owned
source. A good test contribution should include:

- a readable source description under `tests/`
- a generator under `tools/` if machine code or memory images are generated
- generated public COE files only when they are explicitly allowlisted
- expected SEG/LED markers
- documentation explaining scope and limitations
- a verification record if XSim or board evidence is available

Directed public tests should state what they cover and what they do not cover.
They should not claim full RV32I compliance unless a complete verification
method and evidence are provided.
