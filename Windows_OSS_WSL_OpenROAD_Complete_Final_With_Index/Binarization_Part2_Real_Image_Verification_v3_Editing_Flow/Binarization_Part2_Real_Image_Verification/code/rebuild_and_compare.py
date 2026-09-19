from pathlib import Path
from PIL import Image
import numpy as np

BASE_DIR = Path(__file__).resolve().parent
PROJECT_DIR = BASE_DIR.parent
DATA_DIR = PROJECT_DIR / "data"
IMAGE_DIR = PROJECT_DIR / "images"

GOLDEN = DATA_DIR / "golden_binary.txt"
RTL = BASE_DIR / "rtl_binary.txt"
OUT = IMAGE_DIR / "sample_binary_rtl.png"

if not RTL.exists():
    raise SystemExit(f"Missing RTL output: {RTL}\nRun the Verilog simulation first.")

golden = np.loadtxt(GOLDEN, dtype=np.uint8)
rtl = np.loadtxt(RTL, dtype=np.uint8)

if rtl.size != golden.size:
    raise SystemExit(f"size mismatch: RTL={rtl.size}, golden={golden.size}")

mismatch = int(np.count_nonzero(rtl != golden))
accuracy = (1 - mismatch / golden.size) * 100

Image.fromarray((rtl.reshape(256, 256) * 255).astype(np.uint8), mode="L").save(OUT)

print(f"Total pixels    : {golden.size}")
print(f"Matched pixels  : {golden.size - mismatch}")
print(f"Mismatch pixels : {mismatch}")
print(f"Accuracy        : {accuracy:.2f}%")
print(f"RTL image       : {OUT}")
print("Result          : PASS" if mismatch == 0 else "Result          : FAIL")
