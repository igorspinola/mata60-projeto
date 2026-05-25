-- Query 12: Top 5 publicações com mais revisões
-- Objetivo: Listar as 5 publicações que passaram pelo maior número de revisões.
-- Tabelas: publicacao, revisao, revisor
-- Funções: JOIN + GROUP BY + COUNT + WINDOW (ROW_NUMBER)
-- Requisito: identificar publicações controversas

SELECT *
FROM (
    SELECT
        pub.id_publicacao,
        pub.no_titulo,
        tp.no_tipo_publicacao,
        COUNT(rev.id_revisor) AS qt_revisoes,
        ROW_NUMBER() OVER (
            PARTITION BY tp.no_tipo_publicacao
            ORDER BY COUNT(rev.id_revisor) DESC
        ) AS row_num
    FROM tb_publicacao pub
    JOIN rl_revisao rev ON pub.id_publicacao = rev.id_publicacao
    JOIN tb_tipo_publicacao tp ON pub.cd_tipo_publicacao = tp.id_tipo_publicacao
    GROUP BY pub.id_publicacao, pub.no_titulo, tp.no_tipo_publicacao
) AS base
WHERE row_num <= 5
ORDER BY no_tipo_publicacao, row_num;