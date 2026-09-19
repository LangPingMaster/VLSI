#!/usr/bin/env bash
set -euo pipefail
DIR="${1:-../reports}"
echo "== Route DRC report =="
if [ -e "$DIR/5_route_drc.rpt" ]; then
  if [ ! -s "$DIR/5_route_drc.rpt" ]; then
    echo "PASS: 5_route_drc.rpt is empty (no violations listed in this ORFS report)."
  else
    cat "$DIR/5_route_drc.rpt"
  fi
else
  echo "MISSING: 5_route_drc.rpt"
fi
echo "== Antenna logs =="
for f in grt_antennas.log drt_antennas.log; do
  if [ -e "$DIR/$f" ]; then
    echo "$f : $(stat -c%s "$DIR/$f") bytes"
  fi
done
