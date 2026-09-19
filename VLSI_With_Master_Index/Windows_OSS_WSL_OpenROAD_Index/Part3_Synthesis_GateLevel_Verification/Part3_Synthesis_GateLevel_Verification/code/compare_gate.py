from pathlib import Path
from PIL import Image
import numpy as np

golden = np.loadtxt("../data/golden_binary.txt", dtype=np.uint8)
gate   = np.loadtxt("gate_binary.txt", dtype=np.uint8)

if gate.size != golden.size:
    raise SystemExit(f"size mismatch: GATE={gate.size}, golden={golden.size}")

mismatch = int(np.count_nonzero(gate != golden))
accuracy = (1 - mismatch / golden.size) * 100

Image.fromarray(
    (gate.reshape(256, 256) * 255).astype(np.uint8),
    mode="L"
).save("../images/sample_binary_gate.png")

print("Total pixels:", golden.size)
print("Mismatch pixels:", mismatch)
print("Accuracy: %.2f%%" % accuracy)
print("PASS" if mismatch == 0 else "FAIL")
