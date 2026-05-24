-- Query 9: Receita arrecadada por método de pagamento
-- Objetivo: Somar valor confirmado (CONCLUIDO) por crédito, débito e pix em cada evento.
-- Tabelas: evento, inscricao, status_pagamento
-- Funções: JOIN + GROUP BY
-- Requisito: análise financeira por meio de pagamento

select
    tb_evento.no_evento,
    rl_inscricao.ds_metodo_pagamento,
    count(*) total_metodo,
    sum(tb_evento.vl_preco) as total_vendas
from
    tb_evento
    join rl_inscricao on rl_inscricao.id_evento = tb_evento.id_evento
    join tb_status_pagamento on tb_status_pagamento.id_pagamento = rl_inscricao.cd_status_pagamento
where
    tb_status_pagamento.no_status_pagamento = 'CONCLUIDO'
group by
    tb_evento.no_evento,
    rl_inscricao.ds_metodo_pagamento
order by total_vendas desc;