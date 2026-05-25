-- Query 20: Ficha completa do participante (relatório consolidado)
-- Objetivo: Listar cada participante com total de eventos, total gasto, total publicações aprovadas e ranking de gasto.
-- Tabelas: participante, inscricao, evento, status_pagamento, autoria, publicacao
-- Funções: SUB-CONSULTAS + JOIN + GROUP BY + WINDOW (RANK) + COUNT
-- Requisito: dashboard individual de participante

select tb_participante.id_participante, count(rl_inscricao.id_evento) as tot_eventos,
  count(case when st_aprovado = true then 1 end) as tot_publicacoes_aprovadas,
  sum(vl_preco) as tot_gastos_em_eventos,
  rank() over(
    order by sum(vl_preco) desc
  ) as rank_maior_gasto
  from tb_participante
  left join rl_inscricao on rl_inscricao.id_participante = tb_participante.id_participante
  left join tb_evento on tb_evento.id_evento = rl_inscricao.id_evento
  left join rl_autoria on rl_autoria.id_participante = tb_participante.id_participante
  left join tb_publicacao on tb_publicacao.id_publicacao = rl_autoria.id_publicacao
  group by tb_participante.id_participante
