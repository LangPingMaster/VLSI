#!/usr/bin/env bash
set -euo pipefail
ORFS="${1:-$HOME/OpenROAD-flow-scripts}"
HERE="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ORFS/flow/designs/src/binarization" "$ORFS/flow/designs/nangate45/binarization"
cp "$HERE/designs/src/binarization/binarization.v" "$ORFS/flow/designs/src/binarization/"
cp "$HERE/designs/nangate45/binarization/config.mk" "$ORFS/flow/designs/nangate45/binarization/"
cp "$HERE/designs/nangate45/binarization/constraint.sdc" "$ORFS/flow/designs/nangate45/binarization/"
echo "Installed binarization design into $ORFS/flow/designs"
