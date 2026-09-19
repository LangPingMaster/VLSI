from PIL import Image
from pathlib import Path
THRESHOLD=128
INPUT=Path("../images/drawBbox_result_p2.bmp")
img=Image.open(INPUT).convert("RGB")
gray=img.convert("L")
gray.save("../images/sample_gray.png")
vals=list(gray.getdata())
Path("../data/gray.hex").write_text("\n".join(f"{v:02x}" for v in vals)+"\n")
Path("../data/golden_binary.txt").write_text("\n".join("1" if v>=THRESHOLD else "0" for v in vals)+"\n")
gray.point(lambda p:255 if p>=THRESHOLD else 0).save("../images/sample_binary_golden.png")
print("Prepared",len(vals),"pixels")
