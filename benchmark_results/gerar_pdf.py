#!/usr/bin/env python3
"""Gera PDF com a tabela de tempos de execucao."""
import csv
from pathlib import Path
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import cm
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak
)

HERE = Path(__file__).resolve().parent
CSV = HERE / "aggregated.csv"
PDF = HERE / "tabela_tempos.pdf"

styles = getSampleStyleSheet()
title_style = ParagraphStyle(
    "title", parent=styles["Title"], fontSize=16, spaceAfter=12, alignment=1
)
h2 = ParagraphStyle(
    "h2", parent=styles["Heading2"], fontSize=13, spaceAfter=8, spaceBefore=12
)
body = ParagraphStyle(
    "body", parent=styles["BodyText"], fontSize=10.5, leading=14, alignment=4
)
small = ParagraphStyle(
    "small", parent=styles["BodyText"], fontSize=9, leading=11
)

doc = SimpleDocTemplate(
    str(PDF), pagesize=A4,
    leftMargin=2.0 * cm, rightMargin=2.0 * cm,
    topMargin=2.0 * cm, bottomMargin=2.0 * cm,
)

story = []
story.append(Paragraph("Avaliação de Desempenho — Consultas SQL", title_style))
story.append(Paragraph("MATA60 — Banco de Dados (UFBA)", styles["Italic"]))
story.append(Spacer(1, 0.4 * cm))

story.append(Paragraph("Metodologia", h2))
story.append(Paragraph(
    "Para cumprir o requisito <b>[Q2]</b> — avaliação de desempenho com pelo menos "
    "10 execuções por consulta, média e desvio padrão — cada uma das 30 consultas "
    "(10 intermediárias e 20 avançadas) foi executada <b>10 vezes</b> no "
    "PostgreSQL 16 via <font face='Courier'>EXPLAIN (ANALYZE, TIMING ON)</font>, "
    "sendo coletado o <i>Execution Time</i> reportado pelo planejador. "
    "Antes de cada execução foi emitido <font face='Courier'>DISCARD ALL</font> "
    "para limpar caches de sessão. Foram calculados, por consulta, a média (μ), "
    "o desvio padrão amostral (σ), o mínimo e o máximo dos tempos.",
    body,
))
story.append(Spacer(1, 0.3 * cm))

# Read aggregated data
rows_int, rows_av = [], []
with CSV.open() as f:
    for r in csv.DictReader(f):
        target = rows_int if r["categoria"] == "intermediario" else rows_av
        target.append(r)

header = ["Consulta", "N", "μ (ms)", "σ (ms)", "mín (ms)", "máx (ms)"]

def build_table(title, rows):
    data = [header]
    for r in rows:
        data.append([
            r["query"], r["n"],
            f"{float(r['media_ms']):.3f}",
            f"{float(r['desvio_ms']):.3f}",
            f"{float(r['min_ms']):.3f}",
            f"{float(r['max_ms']):.3f}",
        ])
    tbl = Table(data, colWidths=[2.6 * cm, 1.2 * cm, 2.6 * cm, 2.6 * cm, 2.6 * cm, 2.6 * cm])
    tbl.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#34495e")),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
        ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
        ("FONTSIZE", (0, 0), (-1, -1), 10),
        ("ALIGN", (1, 0), (-1, -1), "RIGHT"),
        ("ALIGN", (0, 0), (0, -1), "CENTER"),
        ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
        ("GRID", (0, 0), (-1, -1), 0.4, colors.grey),
        ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.whitesmoke, colors.white]),
        ("TOPPADDING", (0, 0), (-1, -1), 4),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
    ]))
    return tbl

story.append(Paragraph("Consultas Intermediárias", h2))
story.append(build_table("intermediario", rows_int))
story.append(Spacer(1, 0.4 * cm))

story.append(Paragraph("Consultas Avançadas", h2))
story.append(build_table("avancado", rows_av))
story.append(Spacer(1, 0.4 * cm))

story.append(Paragraph("Observações", h2))
obs = [
    "Banco executado em container Docker (PostgreSQL 16) com o dataset fornecido pelo grupo "
    "(<font face='Courier'>sql_output/00_executar_tudo.sql</font>).",
    "Todas as 30 consultas executaram sem erro nas 10 repetições (N = 10).",
    "Os tempos consideram apenas o <i>Execution Time</i> reportado por "
    "<font face='Courier'>EXPLAIN ANALYZE</font>, excluindo o tempo de planejamento.",
    "Os dados brutos estão em <font face='Courier'>benchmark_results/raw_times.csv</font> "
    "e os agregados em <font face='Courier'>benchmark_results/aggregated.csv</font>.",
]
for item in obs:
    story.append(Paragraph("• " + item, body))
    story.append(Spacer(1, 0.1 * cm))

doc.build(story)
print(f"OK: gerou {PDF}")
