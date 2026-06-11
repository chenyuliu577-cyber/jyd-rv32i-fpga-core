#!/usr/bin/env python3
"""Generate public RV32I smoke-test COE memory images.

The script does not call an external RISC-V assembler. It directly emits a
small, documented RV32I instruction sequence for the repository-owned smoke
test under tests/public-smoke/.
"""

from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = REPO_ROOT / "tests" / "public-memory"
IROM_WORDS = 4096
DRAM_WORDS = 65536


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


def encode_jal(rd: int, offset: int) -> int:
    # RV32I JAL immediate is a signed byte offset. The low bit is implicit.
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


def main() -> None:
    # Program behavior:
    #   x1 = 0x80200000 peripheral base
    #   write 0x80000000 to counter MMIO 0x80200050
    #   write 0x00000037 to SEG MMIO 0x80200020 as a smoke marker
    #   write 0x00000001 to LED MMIO 0x80200040
    #   write 0xffffffff to counter MMIO 0x80200050
    #   loop forever
    program = [
        encode_lui(1, 0x80200),
        encode_lui(2, 0x80000),
        encode_sw(2, 1, 0x50),
        encode_addi(3, 0, 0x37),
        encode_sw(3, 1, 0x20),
        encode_addi(4, 0, 1),
        encode_sw(4, 1, 0x40),
        encode_addi(5, 0, -1),
        encode_sw(5, 1, 0x50),
        encode_jal(0, 0),
    ]

    if len(program) > IROM_WORDS:
        raise RuntimeError("Public smoke program exceeds configured IROM depth")

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    irom_words = program + [0] * (IROM_WORDS - len(program))
    dram_words = [0] * DRAM_WORDS
    write_coe(OUT_DIR / "irom.coe", irom_words)
    write_coe(OUT_DIR / "dram.coe", dram_words)
    print(f"Wrote {OUT_DIR / 'irom.coe'} ({IROM_WORDS} words)")
    print(f"Wrote {OUT_DIR / 'dram.coe'} ({DRAM_WORDS} words)")
    print("Expected SEG smoke marker: raw write value 0x00000037")
    print("This marker is not an RV32I 37/37 verification result.")


if __name__ == "__main__":
    main()
