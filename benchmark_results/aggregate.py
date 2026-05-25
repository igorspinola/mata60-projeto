#!/usr/bin/env python3
"""Agrega tempos do raw_times.csv: calcula media e desvio padrao (amostral) por query.

Saidas:
  - aggregated.csv
  - aggregated.tex (tabela LaTeX pronta para incluir em main.tex)
"""
import csv
import math
import statistics
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
RAW = HERE / "raw_times.csv"
AGG_CSV = HERE / "aggregated.csv"
AGG_TEX = HERE / "aggregated.tex"

times = defaultdict(list)  # (categoria, query) -> [ms]

with RAW.open() as f:
    reader = csv.DictReader(f)
    for row in reader:
        try:
            t = float(row["tempo_ms"])
        except ValueError:
            continue
        times[(row["categoria"], row["query"])].append(t)

# Ordenacao: intermediario primeiro, depois avancado; por numero da query
def sort_key(k):
    cat, q = k
    cat_order = 0 if cat == "intermediario" else 1
    num = int("".join(ch for ch in q if ch.isdigit()))
    return (cat_order, num)

rows = []
for key in sorted(times.keys(), key=sort_key):
    cat, q = key
    vals = times[key]
    mean = statistics.mean(vals)
    stdev = statistics.stdev(vals) if len(vals) > 1 else 0.0
    rows.append({
        "categoria": cat,
        "query": q,
        "n": len(vals),
        "media_ms": mean,
        "desvio_ms": stdev,
        "min_ms": min(vals),
        "max_ms": max(vals),
    })

# CSV agregado
with AGG_CSV.open("w", newline="") as f:
    w = csv.DictWriter(f, fieldnames=["categoria","query","n","media_ms","desvio_ms","min_ms","max_ms"])
    w.writeheader()
    for r in rows:
        w.writerow({
            "categoria": r["categoria"],
            "query": r["query"],
            "n": r["n"],
            "media_ms": f"{r['media_ms']:.4f}",
            "desvio_ms": f"{r['desvio_ms']:.4f}",
            "min_ms": f"{r['min_ms']:.4f}",
            "max_ms": f"{r['max_ms']:.4f}",
        })

# LaTeX
lines = []
lines.append(r"% Tabela gerada automaticamente por benchmark_results/aggregate.py")
lines.append(r"% Cada query foi executada 10 vezes via EXPLAIN ANALYZE no PostgreSQL 16.")
lines.append(r"\begin{table}[H]")
lines.append(r"\centering")
lines.append(r"\caption{Tempos de execu\c{c}\~ao das consultas (10 execu\c{c}\~oes cada via \texttt{EXPLAIN ANALYZE}).}")
lines.append(r"\label{tab:tempos-execucao}")
lines.append(r"\begin{tabular}{|c|r|r|r|r|r|}")
lines.append(r"\hline")
lines.append(r"\textbf{Consulta} & \textbf{N} & $\boldsymbol{\mu}$ \textbf{(ms)} & $\boldsymbol{\sigma}$ \textbf{(ms)} & \textbf{m\'in (ms)} & \textbf{m\'ax (ms)} \\")
lines.append(r"\hline")

# Intermediarias
lines.append(r"\multicolumn{6}{|c|}{\textbf{Consultas Intermedi\'arias}} \\")
lines.append(r"\hline")
for r in rows:
    if r["categoria"] != "intermediario":
        continue
    lines.append(f"{r['query']} & {r['n']} & {r['media_ms']:.3f} & {r['desvio_ms']:.3f} & {r['min_ms']:.3f} & {r['max_ms']:.3f} \\\\")
lines.append(r"\hline")

# Avancadas
lines.append(r"\multicolumn{6}{|c|}{\textbf{Consultas Avan\c{c}adas}} \\")
lines.append(r"\hline")
for r in rows:
    if r["categoria"] != "avancado":
        continue
    lines.append(f"{r['query']} & {r['n']} & {r['media_ms']:.3f} & {r['desvio_ms']:.3f} & {r['min_ms']:.3f} & {r['max_ms']:.3f} \\\\")
lines.append(r"\hline")
lines.append(r"\end{tabular}")
lines.append(r"\end{table}")

AGG_TEX.write_text("\n".join(lines) + "\n")

print(f"OK: gerou {AGG_CSV} e {AGG_TEX}")
print(f"Total de queries: {len(rows)}")
