Part 4 — Technology Library / Standard Cell Mapping / STA / P&R / Post-Layout

延續 Part 3 的同一個 binarization RTL、gray.hex 與 golden_binary.txt。

可直接執行的部分（需安裝 Yosys + Icarus + Python）：
  cd code
  ./run_part4.sh
或 Windows PowerShell：
  .\run_part4.ps1

STA：若系統有 OpenSTA 的 sta 指令，腳本會自動執行 sta.tcl。
P&R：openroad_flow.tcl 是完整教學流程模板，但真正 placement/routing 必須使用課程/PDK 提供的 technology LEF、standard-cell LEF；本 ZIP 不偽造真實製程資料。

重點：Part 4 把 Part 3 的 generic gate verification 推進到 technology mapping、timing constraints、STA，再銜接 P&R / post-layout。
