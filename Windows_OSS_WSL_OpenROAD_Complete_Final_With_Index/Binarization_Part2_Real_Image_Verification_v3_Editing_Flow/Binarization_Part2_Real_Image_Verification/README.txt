Part 2 — Real Image RTL Binarization Verification
=================================================

Main flow
---------
Color BMP -> Grayscale -> gray.hex -> Verilog RTL -> 65,536-pixel Simulation
-> rtl_binary.txt -> Binary Image -> Python Golden Model -> Pixel-by-Pixel Compare -> PASS

Folder structure
----------------
code/
  design.sv                       RTL design
  testbench_image.sv              LOCAL PC testbench; reads ../data/gray.hex
  testbench_image_edaplayground.sv EDA Playground version; reads gray.hex
  prepare_image.py                BMP -> grayscale + gray.hex + Golden Model
  rebuild_and_compare.py          RTL output -> PNG + pixel-by-pixel compare
  run_local.ps1                   Windows PowerShell one-click flow
  run_local.sh                    Linux/macOS shell flow

data/
  gray.hex                        65,536 grayscale pixel values
  golden_binary.txt               Python Golden Model output
images/
  four original BMP files + PNG previews + generated result images
index.html                        Full tutorial
Part2_Full_Flow.png               Part 2 overview poster

Windows / PowerShell
--------------------
1. Open PowerShell in the code folder.
2. Run:
     python prepare_image.py
3. Compile:
     iverilog -g2012 -o simv design.sv testbench_image.sv
4. Simulate:
     vvp simv
5. Compare:
     python rebuild_and_compare.py

Or run all four steps:
     .\run_local.ps1

Important path rule
-------------------
Local PC version:
    $readmemh("../data/gray.hex", img_mem);

EDA Playground version:
    $readmemh("gray.hex", img_mem);
Use testbench_image_edaplayground.sv and place/upload gray.hex in the same online run directory.

Expected final result
---------------------
Total pixels    : 65536
Matched pixels  : 65536
Mismatch pixels : 0
Accuracy        : 100.00%
Result          : PASS

============================================================
完整編輯流程（Windows PowerShell）
============================================================
1. cd code
2. 如需換圖，修改 prepare_image.py 的 INPUT_IMAGE
3. 如需改 threshold，同步確認 prepare_image.py 與 testbench_image.sv 的 threshold 都一致
4. python prepare_image.py
5. 確認 ../data/gray.hex 與 ../data/golden_binary.txt
6. 檢查 design.sv
7. 檢查 testbench_image.sv 使用 $readmemh("../data/gray.hex", img_mem)
8. iverilog -g2012 -o simv design.sv testbench_image.sv
9. vvp simv
10. 確認 code/rtl_binary.txt
11. python rebuild_and_compare.py
12. 只有 mismatch=0 / accuracy=100% 才算 PASS

任何修改後：
- 改圖片 / Golden threshold：先重新跑 prepare_image.py
- 改 RTL / Testbench：重新 compile + simulation
- 最後一定再跑 rebuild_and_compare.py

一鍵執行：
.\run_local.ps1

EDA Playground：
- Design：design.sv
- Testbench：testbench_image_edaplayground.sv
- gray.hex 必須在同層，故 $readmemh("gray.hex", img_mem)
- 完整 65,536 pixels 建議本機跑；EDA Playground 適合示範/抽樣與 Part 3 Yosys Synthesis。
