-- Query 10: Posição de cada evento no ranking de receita (WINDOW)
-- Objetivo: Usar RANK() para mostrar a posição de cada evento pela receita confirmada.
-- Tabelas: evento, inscricao, status_pagamento
-- Funções: JOIN + WINDOW (RANK()) + GROUP BY
-- Requisito: comparar desempenho financeiro entre eventos
SELECT
    e.id_evento,
    e.no_evento,
    SUM(e.vl_preco) AS receita_confirmada,
    RANK() OVER (
        ORDER BY SUM(e.vl_preco) DESC
    ) AS posicao_ranking
FROM
    tb_evento e
    JOIN rl_inscricao i ON e.id_evento = i.id_evento
    JOIN tb_status_pagamento sp ON i.cd_status_pagamento = sp.id_pagamento
WHERE
    sp.no_status_pagamento = 'CONCLUIDO'
GROUP BY
    e.id_evento,
    e.no_evento
ORDER BY posicao_ranking;