-- Query 7: Eventos com receita acima da média (com posição no ranking)
-- Objetivo: Mostrar eventos cuja receita CONCLUIDO supera a média geral, com sua posição no ranking.
-- Tabelas: evento, inscricao, status_pagamento
-- Funções: SUB-CONSULTAS + JOIN + GROUP BY + WINDOW (RANK)
-- Requisito: identificar eventos de alta performance

select * from (
    select tb_evento.id_evento, tb_evento.no_evento,
           sum(tb_evento.vl_preco) as receita,
           avg(sum(tb_evento.vl_preco)) over () as media_geral,
           rank() over (order by sum(tb_evento.vl_preco) desc) as posicao
    from tb_evento
    join rl_inscricao on rl_inscricao.id_evento = tb_evento.id_evento
    join tb_status_pagamento on tb_status_pagamento.id_pagamento = rl_inscricao.cd_status_pagamento
    where tb_status_pagamento.no_status_pagamento = 'CONCLUIDO'
    group by tb_evento.id_evento, tb_evento.no_evento
) dados
where receita > media_geral
order by posicao;
