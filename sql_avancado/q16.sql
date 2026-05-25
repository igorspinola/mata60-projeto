-- Query 16: Receita acumulada por evento (ordem cronológica)
-- Objetivo: Usar SUM() OVER (ORDER BY dh_inicio) para mostrar receita acumulada ao longo do tempo.
-- Tabelas: evento, inscricao, status_pagamento
-- Funções: JOIN + GROUP BY + WINDOW (SUM acumulada)
-- Requisito: análise temporal de receita acumulada

SELECT ev.id_evento,
       ev.no_evento,
       ev.dh_inicio,
       SUM(ev.vl_preco) AS receita_evento,
       SUM(SUM(ev.vl_preco)) OVER (ORDER BY ev.dh_inicio) AS receita_acumulada
FROM tb_evento ev
JOIN rl_inscricao i        ON i.id_evento = ev.id_evento
JOIN tb_status_pagamento sp ON sp.id_pagamento = i.cd_status_pagamento
WHERE sp.no_status_pagamento = 'CONCLUIDO'
GROUP BY ev.id_evento, ev.no_evento, ev.dh_inicio
ORDER BY ev.dh_inicio;
