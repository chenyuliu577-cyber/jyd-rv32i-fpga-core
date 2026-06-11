#!/usr/bin/env python3
"""Generate public RV32I branch-directed COE memory images.

The script does not call an external RISC-V assembler. It directly emits a
small, documented RV32I instruction sequence for the repository-owned branch
test under tests/branch-directed/.
"""

from dataclasses import dataclass
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = REPO_ROOT / "tests" / "branch-memory"
IROM_WORDS = 4096
DRAM_WORDS = 65536

OPCODE_BRANCH = 0x63
FUNCT3_BEQ = 0x0
FUNCT3_BNE = 0x1
FUNCT3_BLT = 0x4
FUNCT3_BGE = 0x5
FUNCT3_BLTU = 0x6
FUNCT3_BGEU = 0x7


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
    return ((imm20 & 0xFFFFF) << 12) | (rd << 7) | 0x37


def encode_addi(rd: int, rs1: int, imm12: int) -> int:
    return ((imm12 & 0xFFF) << 20) | (rs1 << 15) | (0x0 << 12) | (rd << 7) | 0x13


def encode_sw(rs2: int, rs1: int, imm12: int) -> int:
    imm = imm12 & 0xFFF
    imm_11_5 = (imm >> 5) & 0x7F
    imm_4_0 = imm & 0x1F
    return (
        (imm_11_5 << 25)
        | (rs2 << 20)
        | (rs1 << 15)
        | (0x2 << 12)
        | (imm_4_0 << 7)
        | 0x23
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
        | 0x6F
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


def ins_sw(rs2: int, rs1: int, imm12: int, text: str) -> Instruction:
    return Instruction("sw", text, rs1=rs1, rs2=rs2, imm=imm12)


def ins_branch(rs1: int, rs2: int, funct3: int, label: str, text: str) -> Instruction:
    return Instruction("branch", text, rs1=rs1, rs2=rs2, funct3=funct3, label=label)


def ins_jal(rd: int, label: str, text: str) -> Instruction:
    return Instruction("jal", text, rd=rd, label=label)


def label(name: str) -> tuple[str, str]:
    return ("label", name)


def build_program() -> tuple[list[int], list[str]]:
    # x1 is the MMIO peripheral base at 0x80200000.
    # x10 accumulates score bits for each successful branch case.
    # Any unexpected branch behavior jumps to fail.
    items: list[Instruction | tuple[str, str]] = [
        ins_lui(1, 0x80200, "lui x1, 0x80200 ; x1 = peripheral base 0x80200000"),
        ins_addi(10, 0, 0, "addi x10, x0, 0 ; score = 0"),
        ins_addi(2, 0, 5, "addi x2, x0, 5 ; BEQ taken setup"),
        ins_addi(3, 0, 5, "addi x3, x0, 5 ; BEQ taken setup"),
        ins_branch(2, 3, FUNCT3_BEQ, "beq_taken_ok", "beq x2, x3, beq_taken_ok ; expect taken"),
        ins_jal(0, "fail", "jal x0, fail ; BEQ taken failed"),
        label("beq_taken_ok"),
        ins_addi(10, 10, 1, "addi x10, x10, 1 ; score BEQ taken"),
        ins_addi(2, 0, 5, "addi x2, x0, 5 ; BEQ not-taken setup"),
        ins_addi(3, 0, 6, "addi x3, x0, 6 ; BEQ not-taken setup"),
        ins_branch(2, 3, FUNCT3_BEQ, "fail", "beq x2, x3, fail ; expect not taken"),
        ins_addi(10, 10, 2, "addi x10, x10, 2 ; score BEQ not taken"),
        ins_branch(2, 3, FUNCT3_BNE, "bne_taken_ok", "bne x2, x3, bne_taken_ok ; expect taken"),
        ins_jal(0, "fail", "jal x0, fail ; BNE taken failed"),
        label("bne_taken_ok"),
        ins_addi(10, 10, 4, "addi x10, x10, 4 ; score BNE taken"),
        ins_addi(2, 0, 7, "addi x2, x0, 7 ; BNE not-taken setup"),
        ins_addi(3, 0, 7, "addi x3, x0, 7 ; BNE not-taken setup"),
        ins_branch(2, 3, FUNCT3_BNE, "fail", "bne x2, x3, fail ; expect not taken"),
        ins_addi(10, 10, 8, "addi x10, x10, 8 ; score BNE not taken"),
        ins_addi(2, 0, -1, "addi x2, x0, -1 ; BLT signed setup"),
        ins_addi(3, 0, 1, "addi x3, x0, 1 ; BLT signed setup"),
        ins_branch(2, 3, FUNCT3_BLT, "blt_taken_ok", "blt x2, x3, blt_taken_ok ; expect taken"),
        ins_jal(0, "fail", "jal x0, fail ; BLT signed failed"),
        label("blt_taken_ok"),
        ins_addi(10, 10, 16, "addi x10, x10, 16 ; score BLT signed taken"),
        ins_addi(2, 0, 1, "addi x2, x0, 1 ; BGE signed setup"),
        ins_addi(3, 0, -1, "addi x3, x0, -1 ; BGE signed setup"),
        ins_branch(2, 3, FUNCT3_BGE, "bge_taken_ok", "bge x2, x3, bge_taken_ok ; expect taken"),
        ins_jal(0, "fail", "jal x0, fail ; BGE signed failed"),
        label("bge_taken_ok"),
        ins_addi(10, 10, 32, "addi x10, x10, 32 ; score BGE signed taken"),
        ins_addi(2, 0, 1, "addi x2, x0, 1 ; BLTU unsigned setup"),
        ins_addi(3, 0, -1, "addi x3, x0, -1 ; BLTU unsigned setup"),
        ins_branch(2, 3, FUNCT3_BLTU, "bltu_taken_ok", "bltu x2, x3, bltu_taken_ok ; expect taken"),
        ins_jal(0, "fail", "jal x0, fail ; BLTU unsigned failed"),
        label("bltu_taken_ok"),
        ins_addi(10, 10, 64, "addi x10, x10, 64 ; score BLTU unsigned taken"),
        ins_addi(2, 0, -1, "addi x2, x0, -1 ; BGEU unsigned setup"),
        ins_addi(3, 0, 1, "addi x3, x0, 1 ; BGEU unsigned setup"),
        ins_branch(2, 3, FUNCT3_BGEU, "bgeu_taken_ok", "bgeu x2, x3, bgeu_taken_ok ; expect taken"),
        ins_jal(0, "fail", "jal x0, fail ; BGEU unsigned failed"),
        label("bgeu_taken_ok"),
        ins_addi(10, 10, 128, "addi x10, x10, 128 ; score BGEU unsigned taken"),
        ins_addi(11, 0, 255, "addi x11, x0, 255 ; expected branch score"),
        ins_branch(10, 11, FUNCT3_BNE, "fail", "bne x10, x11, fail ; score check"),
        label("success"),
        ins_lui(6, 0x0000C, "lui x6, 0x0000c ; prepare success SEG marker"),
        ins_addi(6, 6, -273, "addi x6, x6, -273 ; x6 = 0x0000beef"),
        ins_sw(6, 1, 0x20, "sw x6, 0x20(x1) ; write success SEG marker"),
        ins_addi(7, 0, 1, "addi x7, x0, 1 ; success LED marker"),
        ins_sw(7, 1, 0x40, "sw x7, 0x40(x1) ; write success LED marker"),
        label("success_loop"),
        ins_jal(0, "success_loop", "jal x0, success_loop ; final self-loop"),
        label("fail"),
        ins_lui(6, 0x0000C, "lui x6, 0x0000c ; prepare failure SEG marker"),
        ins_addi(6, 6, -1328, "addi x6, x6, -1328 ; x6 = 0x0000bad0"),
        ins_sw(6, 1, 0x20, "sw x6, 0x20(x1) ; write failure SEG marker"),
        ins_addi(7, 0, 238, "addi x7, x0, 238 ; failure LED marker"),
        ins_sw(7, 1, 0x40, "sw x7, 0x40(x1) ; write failure LED marker"),
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
        elif item.kind == "sw":
            word = encode_sw(item.rs2 or 0, item.rs1 or 0, item.imm or 0)
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
        raise RuntimeError("Branch directed program exceeds configured IROM depth")

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    irom_words = program + [0] * (IROM_WORDS - len(program))
    dram_words = [0] * DRAM_WORDS
    write_coe(OUT_DIR / "irom.coe", irom_words)
    write_coe(OUT_DIR / "dram.coe", dram_words)
    print(f"Wrote {OUT_DIR / 'irom.coe'} ({IROM_WORDS} words)")
    print(f"Wrote {OUT_DIR / 'dram.coe'} ({DRAM_WORDS} words)")
    print("Branch directed program listing:")
    for line in listing:
        print(line)
    print("Expected success SEG marker: raw write value 0x0000BEEF")
    print("Failure SEG marker: raw write value 0x0000BAD0")
    print("This directed test is not an RV32I 37/37 verification result.")


if __name__ == "__main__":
    main()
