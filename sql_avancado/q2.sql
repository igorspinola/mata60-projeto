-- Query 2: Top 3 revisores mais rigorosos (maior taxa de reprovação)
-- Objetivo: Calcular % de reprovação de cada revisor e mostrar os 3 com maior índice.
-- Tabelas: revisor, revisao, publicacao
-- Funções: JOIN + GROUP BY + WINDOW (RANK) + COUNT
-- Requisito: análise de perfil de revisores
SELECT
    id_revisor,
    no_revisor,
    total_revisoes,
    total_reprovacoes,
    taxa_reprovacao,
    ranking
FROM (
        SELECT
            r.id_revisor, r.no_revisor, COUNT(*) AS total_revisoes, SUM(
                CASE
                    WHEN rv.st_aprovado = false THEN 1
                    ELSE 0
                END
            ) AS total_reprovacoes, ROUND(
                SUM(
                    CASE
                        WHEN rv.st_aprovado = false THEN 1
                        ELSE 0
                    END
                ) * 100.0 / COUNT(*), 2
            ) AS taxa_reprovacao, RANK() OVER (
                ORDER BY SUM(
                        CASE
                            WHEN rv.st_aprovado = false THEN 1
                            ELSE 0
                        END
                    ) * 100.0 / COUNT(*) DESC
            ) AS ranking
        FROM
            tb_revisor r
            JOIN rl_revisao rv ON rv.id_revisor = r.id_revisor
            JOIN tb_publicacao p ON p.id_publicacao = rv.id_publicacao
        GROUP BY
            r.id_revisor, r.no_revisor
    )
WHERE
    ranking <= 3
ORDER BY ranking;