-- Query 4: Distribuição de status de pagamento por evento
-- Objetivo: Quantas inscrições estão CONCLUIDO/PENDENTE/CANCELADO em cada evento.
-- Tabelas: evento, inscricao, status_pagamento
-- Funções: JOIN + GROUP BY + COUNT
-- Requisito: dashboard financeiro do organizador

select rl_inscricao.id_evento, no_status_pagamento, count(nu_inscricao)
from
    rl_inscricao
    join tb_evento on tb_evento.id_evento = rl_inscricao.id_evento
    join tb_status_pagamento on tb_status_pagamento.id_pagamento = rl_inscricao.cd_status_pagamento
group by
    rl_inscricao.id_evento,
    rl_inscricao.cd_status_pagamento,
    no_status_pagamento
order by rl_inscricao.id_evento asc;