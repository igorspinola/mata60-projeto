-- Query 7: Carga de revisão por revisor
-- Objetivo: Listar todos os revisores com a quantidade de publicações que cada um revisou.
-- Tabelas: revisor, revisao, publicacao
-- Funções: JOIN + GROUP BY + COUNT
-- Requisito: redistribuir carga de trabalho entre revisores

SELECT
    r.id_revisor,
    r.no_revisor,
    COUNT(rl.id_publicacao) AS qtd_publicacoes_revisadas
FROM tb_revisor r
    JOIN rl_revisao rl ON r.id_revisor = rl.id_revisor
GROUP BY
    r.id_revisor,
    r.no_revisor
ORDER BY qtd_publicacoes_revisadas DESC;