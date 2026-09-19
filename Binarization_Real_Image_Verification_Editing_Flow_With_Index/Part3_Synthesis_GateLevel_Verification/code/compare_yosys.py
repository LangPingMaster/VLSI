from PIL import Image
import numpy as np

golden = np.loadtxt("../data/golden_binary.txt", dtype=np.uint8)
yosys = np.loadtxt("yosys_binary.txt", dtype=np.uint8)

if yosys.size != golden.size:
    raise SystemExit(
        f"size mismatch: Yosys={yosys.size}, Golden={golden.size}"
    )

mismatch = int(np.count_nonzero(yosys != golden))
accuracy = (1 - mismatch / golden.size) * 100

img = (yosys.reshape(256, 256) * 255).astype(np.uint8)
Image.fromarray(img, mode="L").save("../images/sample_binary_yosys.png")

print("Total pixels:", golden.size)
print("Mismatch pixels:", mismatch)
print("Accuracy: %.2f%%" % accuracy)

if mismatch == 0:
    print("PASS")
else:
    print("FAIL")
