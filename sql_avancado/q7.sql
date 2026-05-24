-- Query 7: Eventos com receita acima da média (com posição no ranking)
-- Objetivo: Mostrar eventos cuja receita CONCLUIDO supera a média geral, com sua posição no ranking.
-- Tabelas: evento, inscricao, status_pagamento
-- Funções: SUB-CONSULTAS + JOIN + GROUP BY + WINDOW (RANK)
-- Requisito: identificar eventos de alta performance

select
    id_evento,
    no_evento,
    receita,
    rank() over (
        order by receita desc
    ) as posicao
from (
        select tb_evento.id_evento, tb_evento.no_evento, sum(tb_evento.vl_preco) as receita
        from
            tb_evento
            join rl_inscricao on rl_inscricao.id_evento = tb_evento.id_evento
            join tb_status_pagamento on tb_status_pagamento.id_pagamento = rl_inscricao.cd_status_pagamento
        where
            tb_status_pagamento.no_status_pagamento = 'CONCLUIDO'
        group by
            tb_evento.id_evento, tb_evento.no_evento
    ) receita_por_evento
where
    receita > (
        select avg(receita)
        from (
                select sum(tb_evento.vl_preco) as receita
                from
                    tb_evento
                    join rl_inscricao on rl_inscricao.id_evento = tb_evento.id_evento
                    join tb_status_pagamento on tb_status_pagamento.id_pagamento = rl_inscricao.cd_status_pagamento
                where
                    tb_status_pagamento.no_status_pagamento = 'CONCLUIDO'
                group by
                    tb_evento.id_evento
            ) med
    )
order by posicao;