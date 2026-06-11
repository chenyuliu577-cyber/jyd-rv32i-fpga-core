# Initial Issues Plan

Do not create these issues automatically. Use this file as the first public
preview issue backlog after the GitHub repository is created.

## 1. Confirm XDC licensing and board-template origin

Why this matters: The constraints file may originate from a board template or
contest package. Public redistribution needs a clear licensing boundary.

Acceptance criteria:

- Identify the source of `fpga/constraints/digital_twin.xdc`.
- Record whether it can be redistributed.
- Update `THIRD_PARTY_NOTICES.md` with the result.

Suggested labels: `licensing`, `documentation`, `release-blocker`

## 2. Confirm XCI redistribution and Vivado IP regeneration path

Why this matters: XCI files are checked in for reconstruction, but long-term
public maintenance should prefer a documented regeneration path where possible.

Acceptance criteria:

- Confirm whether the checked-in XCI files can be redistributed.
- Document Vivado 2023.2 IP parameters for IROM, DRAM, and PLL.
- Decide whether to keep XCI files or replace them with Tcl generation.

Suggested labels: `vivado`, `ip`, `licensing`, `release-blocker`

## 3. Add public self-generated RV32I memory image

Status: addressed by `tests/public-smoke/`, `tests/public-memory/`, and
`tools/gen_public_smoke_memory.py`. This is a public smoke memory flow only,
not a public RV32I 37/37 verification package.

Why this matters: Current 37/37 verification depends on private memory images
that are not included in Git.

Acceptance criteria:

- Add a self-generated or clearly redistributable RV32I memory image.
- Document how it was built.
- Add a verification record that does not depend on private contest memory.

Suggested labels: `verification`, `memory`, `good-first-project`

## 4. Add CI syntax/lint workflow

Status: addressed; implemented by `.github/workflows/repo-hygiene.yml`.
This is a repository hygiene and whitespace workflow only, not a full lint,
Vivado, XSim, HDL verification, or RV32I correctness workflow.

Why this matters: The repository currently has no automated checks for pull
requests.

Acceptance criteria:

- Add a GitHub Actions workflow for syntax or lint checks.
- Do not require proprietary Vivado in public CI unless a legal runner path is documented.
- Document local equivalents in `docs/quickstart.md`.

Suggested labels: `ci`, `quality`, `automation`

## 5. Add Verilator compile-only check

Why this matters: Verilator can provide a lightweight open-source syntax check
for contributors who do not have Vivado.

Acceptance criteria:

- Add a documented Verilator compile-only command or script.
- Resolve or document unsupported vendor IP stubs.
- Keep the check honest; do not claim full simulation if only syntax is checked.

Suggested labels: `verilator`, `simulation`, `quality`

## 6. Add memory map diagram

Status: addressed by `docs/memory-map.md` as the implementation target for
GitHub Issue #7.

Why this matters: A visual memory map helps readers understand IROM, DRAM, MMIO,
SEG, LED, switches, keys, and counter regions.

Acceptance criteria:

- Add a diagram to `docs/architecture.md` or a linked document.
- Match addresses used in RTL.
- Mark any uncertain behavior as pending confirmation.

Suggested labels: `documentation`, `architecture`, `good-first-issue`

## 7. Add directed branch instruction tests

Why this matters: Branch handling is a common source of CPU correctness bugs.

Acceptance criteria:

- Add directed tests for taken and not-taken conditional branches.
- Include forward and backward branch cases.
- Record how expected results are checked.

Suggested labels: `verification`, `rv32i`, `branch`

## 8. Add directed load/store byte-halfword tests

Why this matters: Byte and halfword sign/zero extension and write masks are
high-risk areas in RV32I implementations.

Acceptance criteria:

- Add tests for `lb`, `lbu`, `lh`, `lhu`, `lw`, `sb`, `sh`, and `sw`.
- Include aligned byte and halfword lane cases.
- Record expected register or memory signatures.

Suggested labels: `verification`, `rv32i`, `memory`

## 9. Add board verification record template

Why this matters: Board evidence needs a consistent format distinct from XSim
simulation evidence.

Acceptance criteria:

- Add a board-specific verification template.
- Include board, Vivado version, bitstream source commit, SEG/LED observations, and photos policy.
- State that private memory and generated bitstreams should not be committed.

Suggested labels: `documentation`, `verification`, `board`

## 10. Add performance verification record

Why this matters: The repository should not claim performance results until
counter start/stop, display units, and computation correctness are verified.

Acceptance criteria:

- Add a performance verification record using an authorized test program.
- Record counter start command, stop command, displayed time, units, and result correctness.
- Clearly state whether evidence comes from XSim or board execution.

Suggested labels: `performance`, `verification`, `release-blocker`
