#!/usr/bin/env bash
set -euo pipefail
R="${1:-../reports}"
echo "======================================"
echo " Part 5 Sign-off Snapshot"
echo "======================================"
grep -Ei "tns max|wns max|worst slack max|period_min|fmax|setup violation count|hold violation count|max slew violation count|max fanout violation count|max cap violation count" "$R/6_finish.rpt" || true
echo
if [ -e "$R/5_route_drc.rpt" ] && [ ! -s "$R/5_route_drc.rpt" ]; then
  echo "Route DRC report: no violations listed"
else
  echo "Route DRC report: inspect manually"
fi
echo "LEC: requires explicit equivalence PASS log"
echo "LVS: not demonstrated by the current Part 4 artifact set"
