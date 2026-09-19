#!/usr/bin/env bash
set -euo pipefail
BASE="${1:-../inputs}"
echo "== LEC handoff artifacts =="
for f in 1_synth_lec.v 6_final_lec.v; do
  if [ -s "$BASE/$f" ]; then
    echo "FOUND: $BASE/$f"
  else
    echo "MISSING: $BASE/$f"
  fi
done
echo
echo "NOTE: Presence of LEC netlists is not itself proof of equivalence."
echo "Use the ORFS LEC/check target or a formal equivalence tool and retain its PASS log."
