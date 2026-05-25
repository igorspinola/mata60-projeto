-- Query 11: Diferença entre receita real e potencial
-- Objetivo: Mostrar receita potencial (todas inscrições) vs real (só CONCLUIDO) e a perda percentual.
-- Tabelas: evento, inscricao, status_pagamento
-- Funções: SUB-CONSULTAS + JOIN + GROUP BY
-- Requisito: medir inadimplência por evento

SELECT
    pot.id_evento,
    pot.no_evento,
    pot.vl_potencial,
    real.vl_real,
    ROUND(((pot.vl_potencial - real.vl_real) / pot.vl_potencial * 100), 2) AS perc_perda
FROM (
    SELECT
        e.id_evento,
        e.no_evento,
        e.vl_preco,
        COUNT(ins.nu_inscricao) AS qt_inscritos,
        (e.vl_preco * COUNT(ins.nu_inscricao)) AS vl_potencial
    FROM tb_evento e
    JOIN rl_inscricao ins ON e.id_evento = ins.id_evento
    GROUP BY e.id_evento, e.no_evento, e.vl_preco
) AS pot
JOIN (
    SELECT
        e.id_evento,
        (e.vl_preco * COUNT(ins.nu_inscricao)) AS vl_real
    FROM tb_evento e
    JOIN rl_inscricao ins ON e.id_evento = ins.id_evento
    JOIN tb_status_pagamento st ON ins.cd_status_pagamento = st.id_pagamento
    WHERE st.no_status_pagamento = 'CONCLUIDO'
    GROUP BY e.id_evento, e.vl_preco
) AS real ON pot.id_evento = real.id_evento
ORDER BY perc_perda DESC;