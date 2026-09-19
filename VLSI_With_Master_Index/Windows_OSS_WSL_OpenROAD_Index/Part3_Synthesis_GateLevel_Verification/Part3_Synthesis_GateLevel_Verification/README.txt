Part 3 - Synthesis & Gate-Level Verification

Goal:
Use the exact same 256x256 image data and Golden Model from Part 2,
then verify that a structural/gate-level implementation still produces
the same 65,536 binary pixels.

Start:
  Open index.html

Windows PowerShell:
  cd code
  .\run_part3.ps1

Linux / Git Bash:
  cd code
  chmod +x run_part3.sh
  ./run_part3.sh

Notes:
- synthesis.ys is the Yosys synthesis flow.
- binarization_gate_reference.v is an included generic structural reference
  so Gate-Level Verification can run immediately even before Yosys is installed.
- Actual Yosys output is written as binarization_yosys.v when Yosys is available.
