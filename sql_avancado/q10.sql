-- Query 10: Posição de cada evento dentro do seu local
-- Objetivo: Usar RANK() OVER (PARTITION BY ds_local) para rankear eventos dentro de cada local.
-- Tabelas: evento, inscricao, status_pagamento
-- Funções: JOIN + GROUP BY + WINDOW (RANK com PARTITION) + COUNT
-- Requisito: comparar eventos dentro do mesmo local

SELECT
    *,
    RANK() OVER (PARTITION BY ds_local ORDER BY qt_inscritos DESC) AS rank_no_local
FROM (
    SELECT
        e.id_evento,
        e.no_evento,
        e.qt_vagas,
        e.ds_local,
        COUNT(ins.nu_inscricao) AS qt_inscritos
    FROM tb_evento e
   JOIN rl_inscricao ins ON e.id_evento = ins.id_evento
    JOIN tb_status_pagamento st ON ins.cd_status_pagamento = st.id_pagamento
    WHERE st.no_status_pagamento = 'CONCLUIDO'
    GROUP BY e.id_evento, e.no_evento, e.qt_vagas, e.ds_local
) AS base
ORDER BY ds_local, rank_no_local;
