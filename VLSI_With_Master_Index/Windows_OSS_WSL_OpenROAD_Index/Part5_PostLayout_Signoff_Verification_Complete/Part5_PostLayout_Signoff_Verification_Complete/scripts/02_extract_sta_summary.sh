#!/usr/bin/env bash
set -euo pipefail
RPT="${1:-../reports/6_finish.rpt}"
echo "== Final STA / electrical checks =="
grep -Ei "tns max|wns max|worst slack max|period_min|fmax|setup violation count|hold violation count|max slew violation count|max fanout violation count|max cap violation count" "$RPT" || true
