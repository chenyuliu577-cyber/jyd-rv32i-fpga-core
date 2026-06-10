# Title

Add a timing report template

## Background

The repository excludes Vivado timing reports, but maintainers still need a standard way to summarize timing results without committing generated reports.

## Expected Work

- Add a Markdown timing report template under `docs/`.
- Include Vivado version, part, clock settings, WNS/TNS summary, and notes.
- Include a reminder not to commit raw generated reports.

## Acceptance Criteria

- The template is easy to copy for future release notes.
- It does not include fabricated timing data.
- It documents the measurement environment fields.
- No `*.rpt` or generated Vivado files are added.

## Difficulty

Good first issue.

## Files Likely Involved

- `docs/`
- `docs/public-release-checklist.md`
