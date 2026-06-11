#!/usr/bin/env python3
"""Generate public RV32I load/store-directed COE memory images.

The script does not call an external RISC-V assembler. It directly emits a
small, documented RV32I instruction sequence for the repository-owned
load/store directed test under tests/load-store-directed/.
"""

from dataclasses import dataclass
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = REPO_ROOT / "tests" / "load-store-memory"
IROM_WORDS = 4096
DRAM_WORDS = 65536

OPCODE_LOAD = 0x03
OPCODE_STORE = 0x23
OPCODE_BRANCH = 0x63
OPCODE_OP_IMM = 0x13
OPCODE_LUI = 0x37
OPCODE_JAL = 0x6F

FUNCT3_LB = 0x0
FUNCT3_LH = 0x1
FUNCT3_LW = 0x2
FUNCT3_LBU = 0x4
FUNCT3_LHU = 0x5
FUNCT3_SB = 0x0
FUNCT3_SH = 0x1
FUNCT3_SW = 0x2
FUNCT3_BNE = 0x1


@dataclass(frozen=True)
class Instruction:
    kind: str
    text: str
    rd: int | None = None
    rs1: int | None = None
    rs2: int | None = None
    imm: int | None = None
    funct3: int | None = None
    label: str | None = None


def encode_lui(rd: int, imm20: int) -> int:
    return ((imm20 & 0xFFFFF) << 12) | (rd << 7) | OPCODE_LUI


def encode_addi(rd: int, rs1: int, imm12: int) -> int:
    return ((imm12 & 0xFFF) << 20) | (rs1 << 15) | (0x0 << 12) | (rd << 7) | OPCODE_OP_IMM


def encode_load(rd: int, rs1: int, imm12: int, funct3: int) -> int:
    return ((imm12 & 0xFFF) << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | OPCODE_LOAD


def encode_store(rs2: int, rs1: int, imm12: int, funct3: int) -> int:
    imm = imm12 & 0xFFF
    imm_11_5 = (imm >> 5) & 0x7F
    imm_4_0 = imm & 0x1F
    return (
        (imm_11_5 << 25)
        | (rs2 << 20)
        | (rs1 << 15)
        | (funct3 << 12)
        | (imm_4_0 << 7)
        | OPCODE_STORE
    )


def encode_branch(rs1: int, rs2: int, funct3: int, offset: int) -> int:
    # RV32I branch immediate is a signed byte offset from the branch PC.
    if offset % 2 != 0:
        raise ValueError(f"Branch offset must be 2-byte aligned: {offset}")
    if offset < -4096 or offset > 4094:
        raise ValueError(f"Branch offset out of range: {offset}")
    imm = offset & 0x1FFF
    bit12 = (imm >> 12) & 0x1
    bit11 = (imm >> 11) & 0x1
    bits10_5 = (imm >> 5) & 0x3F
    bits4_1 = (imm >> 1) & 0xF
    return (
        (bit12 << 31)
        | (bits10_5 << 25)
        | (rs2 << 20)
        | (rs1 << 15)
        | (funct3 << 12)
        | (bits4_1 << 8)
        | (bit11 << 7)
        | OPCODE_BRANCH
    )


def encode_jal(rd: int, offset: int) -> int:
    # RV32I JAL immediate is a signed byte offset from the JAL PC.
    if offset % 2 != 0:
        raise ValueError(f"JAL offset must be 2-byte aligned: {offset}")
    if offset < -(1 << 20) or offset > (1 << 20) - 2:
        raise ValueError(f"JAL offset out of range: {offset}")
    imm = offset & 0x1FFFFF
    bit20 = (imm >> 20) & 0x1
    bits10_1 = (imm >> 1) & 0x3FF
    bit11 = (imm >> 11) & 0x1
    bits19_12 = (imm >> 12) & 0xFF
    return (
        (bit20 << 31)
        | (bits10_1 << 21)
        | (bit11 << 20)
        | (bits19_12 << 12)
        | (rd << 7)
        | OPCODE_JAL
    )


def write_coe(path: Path, words: list[int]) -> None:
    lines = [
        "memory_initialization_radix=16;",
        "memory_initialization_vector=",
    ]
    for index, word in enumerate(words):
        terminator = ";" if index == len(words) - 1 else ","
        lines.append(f"{word & 0xFFFFFFFF:08x}{terminator}")
    path.write_text("\n".join(lines) + "\n", encoding="ascii")


def ins_lui(rd: int, imm20: int, text: str) -> Instruction:
    return Instruction("lui", text, rd=rd, imm=imm20)


def ins_addi(rd: int, rs1: int, imm12: int, text: str) -> Instruction:
    return Instruction("addi", text, rd=rd, rs1=rs1, imm=imm12)


def ins_load(rd: int, rs1: int, imm12: int, funct3: int, text: str) -> Instruction:
    return Instruction("load", text, rd=rd, rs1=rs1, imm=imm12, funct3=funct3)


def ins_store(rs2: int, rs1: int, imm12: int, funct3: int, text: str) -> Instruction:
    return Instruction("store", text, rs1=rs1, rs2=rs2, imm=imm12, funct3=funct3)


def ins_branch(rs1: int, rs2: int, funct3: int, label: str, text: str) -> Instruction:
    return Instruction("branch", text, rs1=rs1, rs2=rs2, funct3=funct3, label=label)


def ins_jal(rd: int, label: str, text: str) -> Instruction:
    return Instruction("jal", text, rd=rd, label=label)


def label(name: str) -> tuple[str, str]:
    return ("label", name)


def nop() -> Instruction:
    return ins_addi(0, 0, 0, "addi x0, x0, 0 ; nop")


def build_program() -> tuple[list[int], list[str]]:
    # x1 is the DRAM base at 0x80100000.
    # x2 is the MMIO peripheral base at 0x80200000.
    # Any unexpected load/store behavior jumps to fail.
    items: list[Instruction | tuple[str, str]] = [
        ins_lui(1, 0x80100, "lui x1, 0x80100 ; x1 = DRAM base 0x80100000"),
        ins_lui(2, 0x80200, "lui x2, 0x80200 ; x2 = peripheral base 0x80200000"),
        ins_lui(3, 0x12345, "lui x3, 0x12345 ; x3 = 0x12345000"),
        ins_addi(3, 3, 0x678, "addi x3, x3, 0x678 ; x3 = 0x12345678"),
        ins_store(3, 1, 0, FUNCT3_SW, "sw x3, 0(x1) ; SW word store"),
        nop(),
        ins_load(4, 1, 0, FUNCT3_LW, "lw x4, 0(x1) ; LW word load"),
        ins_branch(4, 3, FUNCT3_BNE, "fail", "bne x4, x3, fail ; SW/LW mismatch"),
        ins_lui(5, 0x00008, "lui x5, 0x00008 ; x5 = 0x00008000"),
        ins_addi(5, 5, 1, "addi x5, x5, 1 ; x5 = 0x00008001"),
        ins_store(5, 1, 4, FUNCT3_SH, "sh x5, 4(x1) ; SH lower halfword store"),
        nop(),
        ins_load(6, 1, 4, FUNCT3_LH, "lh x6, 4(x1) ; LH signed load, expect 0xffff8001"),
        ins_lui(7, 0xFFFF8, "lui x7, 0xffff8 ; x7 = 0xffff8000"),
        ins_addi(7, 7, 1, "addi x7, x7, 1 ; x7 = 0xffff8001"),
        ins_branch(6, 7, FUNCT3_BNE, "fail", "bne x6, x7, fail ; SH/LH sign-extension mismatch"),
        ins_store(5, 1, 6, FUNCT3_SH, "sh x5, 6(x1) ; SH upper halfword store"),
        nop(),
        ins_load(6, 1, 6, FUNCT3_LHU, "lhu x6, 6(x1) ; LHU unsigned load, expect 0x00008001"),
        ins_branch(6, 5, FUNCT3_BNE, "fail", "bne x6, x5, fail ; SH/LHU zero-extension mismatch"),
        ins_addi(8, 0, 0x80, "addi x8, x0, 0x80 ; x8 = 0x00000080"),
        ins_store(8, 1, 8, FUNCT3_SB, "sb x8, 8(x1) ; SB byte lane 0"),
        nop(),
        ins_load(9, 1, 8, FUNCT3_LB, "lb x9, 8(x1) ; LB signed load, expect 0xffffff80"),
        ins_addi(10, 0, -128, "addi x10, x0, -128 ; x10 = 0xffffff80"),
        ins_branch(9, 10, FUNCT3_BNE, "fail", "bne x9, x10, fail ; SB/LB sign-extension mismatch"),
        ins_store(8, 1, 11, FUNCT3_SB, "sb x8, 11(x1) ; SB byte lane 3"),
        nop(),
        ins_load(9, 1, 11, FUNCT3_LBU, "lbu x9, 11(x1) ; LBU unsigned load, expect 0x00000080"),
        ins_branch(9, 8, FUNCT3_BNE, "fail", "bne x9, x8, fail ; SB/LBU zero-extension mismatch"),
        label("success"),
        ins_lui(6, 0x0000C, "lui x6, 0x0000c ; prepare success SEG marker"),
        ins_addi(6, 6, 0x0DE, "addi x6, x6, 0x0de ; x6 = 0x0000c0de"),
        ins_store(6, 2, 0x20, FUNCT3_SW, "sw x6, 0x20(x2) ; write success SEG marker"),
        ins_addi(7, 0, 1, "addi x7, x0, 1 ; success LED marker"),
        ins_store(7, 2, 0x40, FUNCT3_SW, "sw x7, 0x40(x2) ; write success LED marker"),
        label("success_loop"),
        ins_jal(0, "success_loop", "jal x0, success_loop ; final self-loop"),
        label("fail"),
        ins_lui(6, 0x0000C, "lui x6, 0x0000c ; prepare failure SEG marker"),
        ins_addi(6, 6, -1328, "addi x6, x6, -1328 ; x6 = 0x0000bad0"),
        ins_store(6, 2, 0x20, FUNCT3_SW, "sw x6, 0x20(x2) ; write failure SEG marker"),
        ins_addi(7, 0, 238, "addi x7, x0, 238 ; failure LED marker"),
        ins_store(7, 2, 0x40, FUNCT3_SW, "sw x7, 0x40(x2) ; write failure LED marker"),
        label("fail_loop"),
        ins_jal(0, "fail_loop", "jal x0, fail_loop ; failure self-loop"),
    ]

    labels: dict[str, int] = {}
    pc = 0
    for item in items:
        if isinstance(item, tuple):
            labels[item[1]] = pc
        else:
            pc += 4

    words: list[int] = []
    listing: list[str] = []
    pc = 0
    for item in items:
        if isinstance(item, tuple):
            listing.append(f"{item[1]}:")
            continue
        if item.kind == "lui":
            word = encode_lui(item.rd or 0, item.imm or 0)
        elif item.kind == "addi":
            word = encode_addi(item.rd or 0, item.rs1 or 0, item.imm or 0)
        elif item.kind == "load":
            word = encode_load(item.rd or 0, item.rs1 or 0, item.imm or 0, item.funct3 or 0)
        elif item.kind == "store":
            word = encode_store(item.rs2 or 0, item.rs1 or 0, item.imm or 0, item.funct3 or 0)
        elif item.kind == "branch":
            offset = labels[item.label or ""] - pc
            word = encode_branch(item.rs1 or 0, item.rs2 or 0, item.funct3 or 0, offset)
        elif item.kind == "jal":
            offset = labels[item.label or ""] - pc
            word = encode_jal(item.rd or 0, offset)
        else:
            raise RuntimeError(f"Unknown instruction kind: {item.kind}")
        words.append(word)
        listing.append(f"0x{pc:04x}: {word:08x}    {item.text}")
        pc += 4

    return words, listing


def main() -> None:
    program, listing = build_program()
    if len(program) > IROM_WORDS:
        raise RuntimeError("Load/store directed program exceeds configured IROM depth")

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    irom_words = program + [0] * (IROM_WORDS - len(program))
    dram_words = [0] * DRAM_WORDS
    write_coe(OUT_DIR / "irom.coe", irom_words)
    write_coe(OUT_DIR / "dram.coe", dram_words)
    print(f"Wrote {OUT_DIR / 'irom.coe'} ({IROM_WORDS} words)")
    print(f"Wrote {OUT_DIR / 'dram.coe'} ({DRAM_WORDS} words)")
    print("Load/store directed program listing:")
    for line in listing:
        print(line)
    print("Expected success SEG marker: raw write value 0x0000C0DE")
    print("Failure SEG marker: raw write value 0x0000BAD0")
    print("This directed test is not an RV32I 37/37 verification result.")


if __name__ == "__main__":
    main()
