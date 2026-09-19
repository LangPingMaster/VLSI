from pathlib import Path
base=Path(__file__).resolve().parent
gate=[int(x) for x in (base/'mapped_binary.txt').read_text().split()]
gold=[int(x) for x in (base.parent/'data'/'golden_binary.txt').read_text().split()]
n=min(len(gate),len(gold)); mis=sum(a!=b for a,b in zip(gate[:n],gold[:n])); acc=100*(n-mis)/n if n else 0
print(f"Total pixels: {n}\nMismatch pixels: {mis}\nAccuracy: {acc:.2f}%\n"+('PASS' if n==65536 and mis==0 else 'FAIL'))
