#!/usr/bin/env python3
"""Compara baseline x plano1 x plano2 x plano3.

Calcula media por query em cada cenario e speedup S = mu_baseline / mu_plano.
Gera:
  - comparativo.csv
  - comparativo.tex (tabela LaTeX pronta para o main.tex)
"""
import csv
import statistics
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
SOURCES = {
    "baseline": HERE / "raw_times_baseline.csv",
    "plano1":   HERE / "raw_times_plano1.csv",
    "plano2":   HERE / "raw_times_plano2.csv",
    "plano3":   HERE / "raw_times_plano3.csv",
}
OUT_CSV = HERE / "comparativo.csv"
OUT_TEX = HERE / "comparativo.tex"


def load(path):
    times = defaultdict(list)  # (categoria, query) -> [ms]
    with path.open() as f:
        for row in csv.DictReader(f):
            try:
                t = float(row["tempo_ms"])
            except ValueError:
                continue
            times[(row["categoria"], row["query"])].append(t)
    return {k: statistics.mean(v) for k, v in times.items()}


data = {name: load(p) for name, p in SOURCES.items()}

# union de chaves, ordenado: intermediario antes, depois por numero
keys = set()
for d in data.values():
    keys.update(d.keys())

def sort_key(k):
    cat, q = k
    cat_order = 0 if cat == "intermediario" else 1
    num = int("".join(ch for ch in q if ch.isdigit()))
    return (cat_order, num)

rows = []
for key in sorted(keys, key=sort_key):
    cat, q = key
    base = data["baseline"].get(key)
    p1 = data["plano1"].get(key)
    p2 = data["plano2"].get(key)
    p3 = data["plano3"].get(key)
    rows.append({
        "categoria": cat,
        "query": q,
        "baseline_ms": base,
        "plano1_ms": p1,
        "plano2_ms": p2,
        "plano3_ms": p3,
        "speedup_p1": base / p1 if base and p1 else None,
        "speedup_p2": base / p2 if base and p2 else None,
        "speedup_p3": base / p3 if base and p3 else None,
    })

# CSV
with OUT_CSV.open("w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["categoria","query","baseline_ms","plano1_ms","plano2_ms","plano3_ms",
                "speedup_p1","speedup_p2","speedup_p3"])
    for r in rows:
        w.writerow([
            r["categoria"], r["query"],
            f"{r['baseline_ms']:.4f}" if r['baseline_ms'] is not None else "",
            f"{r['plano1_ms']:.4f}" if r['plano1_ms'] is not None else "",
            f"{r['plano2_ms']:.4f}" if r['plano2_ms'] is not None else "",
            f"{r['plano3_ms']:.4f}" if r['plano3_ms'] is not None else "",
            f"{r['speedup_p1']:.3f}" if r['speedup_p1'] is not None else "",
            f"{r['speedup_p2']:.3f}" if r['speedup_p2'] is not None else "",
            f"{r['speedup_p3']:.3f}" if r['speedup_p3'] is not None else "",
        ])

# LaTeX -- formato brasileiro (virgula decimal)
def fmt_ms(v):
    return f"{v:.3f}".replace(".", ",") if v is not None else "--"
def fmt_sp(v):
    return f"{v:.2f}".replace(".", ",") if v is not None else "--"

lines = []
lines.append(r"% Tabela gerada automaticamente por benchmark_results/compare_planos.py")
lines.append(r"% Comparacao baseline x 3 planos de indexacao (10 execucoes via EXPLAIN ANALYZE).")
lines.append(r"\begin{longtable}{|c|r|r|r|r|r|r|r|}")
lines.append(r"\caption{Compara\c{c}\~ao dos tempos m\'edios de execu\c{c}\~ao (ms) e \emph{speedup} ($S = \mu_{baseline}/\mu_{plano}$) entre o \emph{baseline} e os tr\^es planos de indexa\c{c}\~ao.}")
lines.append(r"\label{tab:comparativo-planos}\\")
lines.append(r"\hline")
lines.append(r"\textbf{Consulta} & \textbf{Baseline} & \textbf{Plano 1} & \textbf{Plano 2} & \textbf{Plano 3} & $\boldsymbol{S_{P1}}$ & $\boldsymbol{S_{P2}}$ & $\boldsymbol{S_{P3}}$ \\")
lines.append(r"\hline")
lines.append(r"\endfirsthead")
lines.append(r"\hline")
lines.append(r"\textbf{Consulta} & \textbf{Baseline} & \textbf{Plano 1} & \textbf{Plano 2} & \textbf{Plano 3} & $\boldsymbol{S_{P1}}$ & $\boldsymbol{S_{P2}}$ & $\boldsymbol{S_{P3}}$ \\")
lines.append(r"\hline")
lines.append(r"\endhead")

lines.append(r"\multicolumn{8}{|c|}{\textbf{Consultas Intermedi\'arias}} \\")
lines.append(r"\hline")
for r in rows:
    if r["categoria"] != "intermediario":
        continue
    lines.append(f"{r['query']} & {fmt_ms(r['baseline_ms'])} & {fmt_ms(r['plano1_ms'])} & {fmt_ms(r['plano2_ms'])} & {fmt_ms(r['plano3_ms'])} & {fmt_sp(r['speedup_p1'])} & {fmt_sp(r['speedup_p2'])} & {fmt_sp(r['speedup_p3'])} \\\\")
lines.append(r"\hline")

lines.append(r"\multicolumn{8}{|c|}{\textbf{Consultas Avan\c{c}adas}} \\")
lines.append(r"\hline")
for r in rows:
    if r["categoria"] != "avancado":
        continue
    lines.append(f"{r['query']} & {fmt_ms(r['baseline_ms'])} & {fmt_ms(r['plano1_ms'])} & {fmt_ms(r['plano2_ms'])} & {fmt_ms(r['plano3_ms'])} & {fmt_sp(r['speedup_p1'])} & {fmt_sp(r['speedup_p2'])} & {fmt_sp(r['speedup_p3'])} \\\\")
lines.append(r"\hline")

# Resumo: media aritmetica dos speedups
def avg(xs):
    xs = [x for x in xs if x is not None]
    return sum(xs)/len(xs) if xs else None

m1 = avg([r["speedup_p1"] for r in rows])
m2 = avg([r["speedup_p2"] for r in rows])
m3 = avg([r["speedup_p3"] for r in rows])
lines.append(r"\multicolumn{5}{|r|}{\textbf{Speedup m\'edio (aritm\'etico)}} & " + f"\\textbf{{{fmt_sp(m1)}}} & \\textbf{{{fmt_sp(m2)}}} & \\textbf{{{fmt_sp(m3)}}} \\\\")
lines.append(r"\hline")
lines.append(r"\end{longtable}")

OUT_TEX.write_text("\n".join(lines) + "\n")

print(f"OK: gerou {OUT_CSV} e {OUT_TEX}")
print(f"Speedup medio -> Plano1: {m1:.3f} | Plano2: {m2:.3f} | Plano3: {m3:.3f}")
