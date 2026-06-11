# Performance Verification Record Template

## Environment

- Date:
- Commit hash:
- Vivado version:
- OS:
- Board:
- Clock frequency:
- Test type:
  - [ ] XSim simulation
  - [ ] Board run
  - [ ] Other:

## Memory Image

- Memory image source:
  - [ ] Public self-generated smoke memory
  - [ ] Private contest-provided memory
  - [ ] Self-generated benchmark memory
  - [ ] Other:
- Memory files committed: No
- Notes:

## Counter Observation

- Counter address: `0x8020_0050`
- Start command expected: `0x8000_0000`
- Start command observed:
- Stop command expected: `0xFFFF_FFFF`
- Stop command observed:
- Observation method:
  - [ ] RTL signal
  - [ ] testbench display
  - [ ] SEG output
  - [ ] board display
  - [ ] other:

## SEG / LED Output

- SEG raw value:
- SEG interpreted value:
- LED raw value:
- LED interpreted value:

## Performance Result

- Displayed time:
- Unit:
- Is this a simulation result or board result?
- Does this result represent a contest benchmark?
- Is the computation result correct?
- Evidence summary:

## Limitations

- Does not include private memory images.
- Does not include full generated logs unless explicitly allowed.
- Does not imply general benchmark leadership.
- Results must be tied to commit hash, memory image source, and environment.

## Conclusion

- [ ] Pass
- [ ] Partial
- [ ] Fail
