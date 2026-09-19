from pathlib import Path
from PIL import Image
import numpy as np
golden=np.loadtxt("../data/golden_binary.txt",dtype=np.uint8)
rtl=np.loadtxt("rtl_binary.txt",dtype=np.uint8)
if rtl.size != golden.size: raise SystemExit(f"size mismatch: RTL={rtl.size}, golden={golden.size}")
mismatch=int(np.count_nonzero(rtl!=golden))
Image.fromarray((rtl.reshape(256,256)*255).astype(np.uint8),mode="L").save("../images/sample_binary_rtl.png")
print("Total pixels:",golden.size); print("Mismatch pixels:",mismatch); print("Accuracy: %.2f%%"%((1-mismatch/golden.size)*100)); print("PASS" if mismatch==0 else "FAIL")
