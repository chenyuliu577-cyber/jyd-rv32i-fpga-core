# Title

Add a memory map diagram

## Background

The project has a documented memory map for IROM, DRAM, and peripherals. A small diagram would make the SoC layout easier to understand.

## Expected Work

- Add a diagram to `docs/architecture.md` or a new `docs/memory-map.md`.
- Include IROM, DRAM, SW, KEY, SEG, LED, and Counter regions.
- Base the diagram on `rtl/soc/perip_bridge.sv` and `docs/competition-spec.md`.

## Acceptance Criteria

- The diagram matches the documented addresses.
- The source of the address information is stated.
- The diagram does not include unsupported claims about unimplemented regions.
- No generated Vivado files are added.

## Difficulty

Good first issue.

## Files Likely Involved

- `docs/architecture.md`
- `docs/competition-spec.md`
- `rtl/soc/perip_bridge.sv`
