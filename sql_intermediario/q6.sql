-- Query 6: Eventos com 100% das inscrições pagas (ou >= 90% se necessário)
-- Objetivo: Listar eventos onde todas (ou quase todas) as inscrições estão com status CONCLUIDO.
-- Tabelas: evento, inscricao, status_pagamento
-- Funções: JOIN + GROUP BY + COUNT (com HAVING)
-- Requisito: identificar eventos sem inadimplência
-- Nota: se retornar vazio com dados reais, ajustar para >= 90% das inscrições pagas

select distinct (tb_evento.id_evento),
    no_evento
from tb_evento
    join (
        select rl_inscricao.id_evento, count(nu_inscricao) as tot_sem_pagar
        from rl_inscricao
            join tb_evento on tb_evento.id_evento = rl_inscricao.id_evento
        where
            cd_status_pagamento = 2
            or cd_status_pagamento = 3
        group by
            rl_inscricao.id_evento
    ) ta on ta.id_evento = tb_evento.id_evento
WHERE
    ta.tot_sem_pagar < 1
order by tb_evento.id_evento asc;