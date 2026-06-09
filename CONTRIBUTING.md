# Contributing

## Bug Reports

Please include:

- Vivado version.
- FPGA board or simulation environment.
- Memory initialization files used, if shareable.
- Expected behavior.
- Actual SEG/LED/UART behavior.
- Minimal reproduction steps.

## Verification Reports

Use `.github/ISSUE_TEMPLATE/verification_report.md`. Include enough evidence for others to reproduce the run.

## RTL Changes

RTL changes should:

- Describe whether functional behavior changes.
- Include simulation or board evidence.
- Avoid special-casing fixed test programs or fixed IROM contents.
- Keep generated Vivado files out of the commit.

## Coding Style

- Keep module names and signal style consistent with the existing RTL.
- Prefer small, reviewable changes.
- Add comments only where they clarify non-obvious hardware behavior.

## PR Checklist

- No generated Vivado directories.
- No bitstream, checkpoint, report, waveform, log, or crash dump files.
- No local absolute paths or machine identifiers.
- Tests or verification steps are documented.
- Performance changes include measurement conditions.

