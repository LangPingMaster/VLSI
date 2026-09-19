#!/usr/bin/env bash
set -euo pipefail
BASE="${1:-.}"
echo "== Part 5 final artifact check =="
for f in 6_final.gds 6_final.def 6_final.odb 6_final.v 6_final.sdc 6_final.spef 6_final_lec.v; do
  if [ -s "$BASE/$f" ]; then
    printf "PASS  %-20s %s bytes\n" "$f" "$(stat -c%s "$BASE/$f")"
  else
    printf "FAIL  %s missing or empty\n" "$f"
  fi
done
