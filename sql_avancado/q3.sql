-- Query 3: Evento mais lucrativo de cada local
-- Objetivo: Para cada ds_local, mostrar qual evento teve maior receita confirmada (CONCLUIDO).
-- Tabelas: evento, inscricao, status_pagamento
-- Funções: JOIN + GROUP BY + WINDOW (RANK) + SUB-CONSULTA
-- Requisito: análise de performance por localização
SELECT *
FROM (
        SELECT
            e.ds_local, e.id_evento, e.no_evento, SUM(e.vl_preco) AS receita_confirmada, RANK() OVER (
                PARTITION BY
                    e.ds_local
                ORDER BY SUM(e.vl_preco) DESC
            ) AS ranking
        FROM
            tb_evento e
            JOIN rl_inscricao i ON i.id_evento = e.id_evento
            JOIN tb_status_pagamento sp ON sp.id_pagamento = i.cd_status_pagamento
        WHERE
            sp.no_status_pagamento = 'CONCLUIDO'
        GROUP BY
            e.ds_local, e.id_evento, e.no_evento
    )
WHERE
    ranking = 1
ORDER BY ds_local;