-- Query 4: Participantes que gastaram acima da média geral
-- Objetivo: Listar participantes cujo gasto total em inscrições CONCLUIDO é maior que a média de todos.
-- Tabelas: participante, inscricao, evento, status_pagamento
-- Funções: SUB-CONSULTAS + JOIN + GROUP BY
-- Requisito: identificar clientes premium
SELECT *
FROM (
        SELECT
            p.id_participante, p.no_participante, SUM(e.vl_preco) AS gasto_total, AVG(SUM(e.vl_preco)) OVER () AS media_geral
        FROM
            tb_participante p
            JOIN rl_inscricao i ON i.id_participante = p.id_participante
            JOIN tb_evento e ON e.id_evento = i.id_evento
            JOIN tb_status_pagamento sp ON sp.id_pagamento = i.cd_status_pagamento
        WHERE
            sp.no_status_pagamento = 'CONCLUIDO'
        GROUP BY
            p.id_participante, p.no_participante
    ) dados
WHERE
    gasto_total > media_geral
ORDER BY gasto_total DESC;