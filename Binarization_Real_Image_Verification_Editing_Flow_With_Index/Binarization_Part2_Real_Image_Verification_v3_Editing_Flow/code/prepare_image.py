from pathlib import Path
from PIL import Image

THRESHOLD = 128
BASE_DIR = Path(__file__).resolve().parent
PROJECT_DIR = BASE_DIR.parent
IMAGE_DIR = PROJECT_DIR / "images"
DATA_DIR = PROJECT_DIR / "data"
INPUT = IMAGE_DIR / "drawBbox_result_p2.bmp"

DATA_DIR.mkdir(exist_ok=True)
IMAGE_DIR.mkdir(exist_ok=True)

img = Image.open(INPUT).convert("RGB")
if img.size != (256, 256):
    raise SystemExit(f"Expected 256x256 image, got {img.size}")

gray = img.convert("L")
gray.save(IMAGE_DIR / "sample_gray.png")
vals = list(gray.getdata())

(DATA_DIR / "gray.hex").write_text(
    "\n".join(f"{v:02x}" for v in vals) + "\n",
    encoding="ascii",
)
(DATA_DIR / "golden_binary.txt").write_text(
    "\n".join("1" if v >= THRESHOLD else "0" for v in vals) + "\n",
    encoding="ascii",
)
gray.point(lambda p: 255 if p >= THRESHOLD else 0).save(
    IMAGE_DIR / "sample_binary_golden.png"
)

print(f"Prepared {len(vals)} pixels")
print(f"gray.hex: {DATA_DIR / 'gray.hex'}")
print(f"golden:   {DATA_DIR / 'golden_binary.txt'}")
