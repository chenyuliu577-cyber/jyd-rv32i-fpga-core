# Public Release Checklist

Use this checklist before the first public GitHub release and before every later release.

## Repository Hygiene

- [ ] Run `scripts/check_clean_repo.ps1`.
- [ ] Confirm no generated Vivado directories are present.
- [ ] Confirm no `*.log`, `*.jou`, `*.dcp`, `*.bit`, `*.wdb`, or `*.dmp` files are present.
- [ ] Confirm no absolute local paths are present.
- [ ] Confirm no personal information is present.
- [ ] Confirm no large generated intermediate files are present.

## Licensing

- [ ] Confirm original RTL ownership.
- [ ] Confirm the source and redistribution status of `fpga/constraints/digital_twin.xdc`.
- [ ] If the XDC comes from a contest/course/vendor template, document the upstream source and redistribution permission.
- [ ] If permission cannot be confirmed, replace it with a maintainer-owned constraint file or keep the repository in public preview only.
- [ ] Confirm XCI redistribution rights, or replace XCI files with documented Tcl IP generation.
- [ ] Confirm testbench source and redistribution rights.
- [ ] Keep memory initialization files excluded unless explicitly authorized for redistribution.
- [ ] Update `THIRD_PARTY_NOTICES.md` when a file category is confirmed or excluded.

## Reproducibility

- [ ] Test `fpga/vivado/create_project.tcl`.
- [ ] Confirm synthesis top module is `top`.
- [ ] Confirm simulation top module is `tb_top`.
- [ ] Confirm `fpga/constraints/digital_twin.xdc` is loaded.
- [ ] Confirm IP files are loaded or regenerated.
- [ ] Confirm memory initialization handling is documented.
- [ ] Confirm whether verification uses private memory images or redistributable public memory images.

## Verification

- [ ] Add at least one verification record before first public release.
- [ ] Do not claim public 37/37 reproducibility unless redistributable memory images or an equivalent public test flow exist.
- [ ] If using private memory verification, state that memory files are not included in Git.
- [ ] Document SEG output.
- [ ] Document LED output.
- [ ] Document counter start/stop and timing result.
- [ ] Identify whether the record is simulation, post-synthesis simulation, or board execution.

## Codex for Open Source Readiness

- [ ] At least one public release.
- [ ] Issue templates.
- [ ] Contribution guide.
- [ ] Roadmap.
- [ ] Verification plan.
- [ ] Good first issues.
- [ ] Honest application statement.
- [ ] No fake usage metrics.
- [ ] No unsupported claims about external users, CI, benchmarks, or production readiness.
