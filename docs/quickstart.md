# Quickstart

## 1. Check the Repository

Run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/check_clean_repo.ps1
```

Expected result:

```text
PASS: repository is clean
```

Do not commit the repository if this check fails.

## 2. Provide Memory Files

This cleanup intentionally excludes memory initialization files. Add your own authorized files under `mem/`:

- `IROM.mif`
- `DRAM.mif`
- `irom.coe`
- `dram.coe`

Then update the Vivado IROM/DRAM IP settings if required.

## 3. Recreate the Vivado Project

Open Vivado Tcl shell from the repository root:

```tcl
source fpga/vivado/create_project.tcl
```

The script creates a local build project under `build/vivado`, adds RTL, testbench files, constraints, and XCI files, and sets `top` as the synthesis top.

## 4. Simulate

Use XSim through Vivado after the project is created. Start with `tb_top` for the top-level path and `tb_uart` for UART-only behavior.

## 5. Verify

Record verification evidence before claiming pass counts or performance numbers. See `docs/verification.md`.

