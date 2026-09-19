# Sign-off status

## Verified by the current run
- Final GDS/DEF/ODB generated.
- Final STA: TNS 0, WNS 0, worst slack +7.73 ns.
- Setup violations: 0.
- Hold violations: 0.
- Max slew / fanout / capacitance violations: 0.
- `5_route_drc.rpt` contains no listed violations (0-byte report).
- Existing antenna logs contain no listed violations (0-byte logs).

## Handoff artifacts present, but explicit PASS evidence still required
- LEC: `1_synth_lec.v` and `6_final_lec.v` are present. Retain an explicit formal-equivalence PASS log.
- LVS: no independent LVS PASS report is included in the Part 4 artifact set.
- Foundry sign-off DRC: ORFS routing checks are not automatically equivalent to a foundry-qualified sign-off deck.
