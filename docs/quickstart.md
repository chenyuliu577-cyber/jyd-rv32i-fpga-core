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

## 2. Generate or Provide Memory Files

The repository includes a public self-generated smoke memory flow. Regenerate
the public memory files with:

```powershell
python tools/gen_public_smoke_memory.py
```

This writes `tests/public-memory/irom.coe` and
`tests/public-memory/dram.coe`. The smoke program writes raw value
`0x00000037` to SEG address `0x8020_0020` as a marker. This marker is not an
RV32I 37/37 result.

This cleanup intentionally excludes private contest memory initialization
files. Add your own authorized private files only under `mem/`:

- `mem/irom.coe`
- `mem/dram.coe`
- `mem/IROM.mif`
- `mem/DRAM.mif`

Do not place private memory files under `fpga/imports/test_src/`, and do not
commit private `.coe` or `.mif` files.

The Vivado project script prefers private `mem/irom.coe` and `mem/dram.coe` if
present. Otherwise it uses the public smoke memory under `tests/public-memory/`
when available.

## 3. Recreate the Vivado Project

Open Vivado Tcl shell from the repository root:

```tcl
source fpga/vivado/create_project.tcl
```

The script creates a local build project under `build/vivado`, adds RTL, testbench files, constraints, and XCI files, and sets `top` as the synthesis top.

## 4. Simulate

Use XSim through Vivado after the project is created. Start with `tb_top` for
the top-level path and `tb_uart` for UART-only behavior. For public smoke
memory, observe the SEG marker `0x00000037`, LED marker `0x00000001`, and
counter start/stop writes as a smoke result only.

## 5. Verify

Record verification evidence before claiming pass counts or performance numbers. See `docs/verification.md`.
