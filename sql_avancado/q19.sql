-- Query 19: Eventos onde a maioria pagou via PIX
-- Objetivo: Listar eventos onde mais de 40% das inscrições CONCLUIDO foram via PIX.
-- Tabelas: evento, inscricao, status_pagamento
-- Funções: SUB-CONSULTAS + JOIN + GROUP BY + COUNT + HAVING
-- Requisito: análise de preferência de pagamento

select id_evento from(
  select id_evento, count(case when ds_metodo_pagamento = 'pix' then 1 end) as total_pix,
    count(nu_inscricao) as total_pago
    from rl_inscricao
    where cd_status_pagamento = 1
    group by id_evento)
where total_pix > total_pago * 0.4
order by id_evento asc
