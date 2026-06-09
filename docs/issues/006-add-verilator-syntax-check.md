# Title

Add a Verilator syntax-check experiment

## Background

The repository currently has no CI or non-Vivado syntax check. A local Verilator syntax check may improve review quality if the RTL can be parsed without changing behavior.

## Expected Work

- Add a local script or documentation for running a Verilator syntax-only check.
- Document any unsupported Vivado IP stubs or required exclusions.
- Do not add a CI badge or workflow until the check is verified.

## Acceptance Criteria

- The script or documentation is reproducible.
- Limitations are documented.
- No generated Verilator output is committed.
- RTL behavior is not changed to satisfy tooling unless separately reviewed.

## Difficulty

Intermediate.

## Files Likely Involved

- `scripts/`
- `docs/verification.md`
- `.gitignore`

