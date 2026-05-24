-- Query 8: Participantes com 2+ inscrições no mesmo mês
-- Objetivo: Listar participantes que tiveram 2 ou mais inscrições no mesmo mês/ano de pagamento.
-- Tabelas: participante, inscricao, evento
-- Funções: JOIN + GROUP BY + COUNT (com HAVING)
-- Requisito: identificar comportamento de consumo intenso

select
    tb_participante.id_participante,
    tb_participante.no_participante,
    extract(
        month
        from rl_inscricao.dh_pagamento
    ) as mes,
    extract(
        year
        from rl_inscricao.dh_pagamento
    ) as ano,
    count(*) as qt_inscricoes
from
    tb_participante
    join rl_inscricao on rl_inscricao.id_participante = tb_participante.id_participante
    join tb_evento on tb_evento.id_evento = rl_inscricao.id_evento
where
    rl_inscricao.dh_pagamento is not null
group by
    tb_participante.id_participante,
    tb_participante.no_participante,
    extract(
        month
        from rl_inscricao.dh_pagamento
    ),
    extract(
        year
        from rl_inscricao.dh_pagamento
    )
having
    count(*) > 1
order by qt_inscricoes desc, no_participante;