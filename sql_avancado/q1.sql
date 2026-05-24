-- Query 1: Participantes que publicaram em TODOS os eventos que se inscreveram
-- Objetivo: Listar participantes que têm publicação aprovada em cada evento no qual se inscreveram.
-- Tabelas: participante, inscricao, autoria, publicacao, anais
-- Funções: SUB-CONSULTAS + JOIN + GROUP BY + COUNT
-- Requisito: identificar pesquisadores extremamente ativos
select p.id_participante, p.no_participante, COUNT(DISTINCT i.id_evento) AS eventos_inscritos
FROM
    tb_participante p
    JOIN rl_inscricao i ON p.id_participante = i.id_participante
WHERE
    NOT EXISTS (
        SELECT 1
        FROM rl_inscricao i2
        WHERE
            i2.id_participante = p.id_participante
            AND NOT EXISTS (
                SELECT 1
                FROM
                    rl_autoria a
                    JOIN tb_publicacao pub ON a.id_publicacao = pub.id_publicacao
                    JOIN rl_anais an ON pub.id_publicacao = an.id_publicacao
                WHERE
                    a.id_participante = p.id_participante
                    AND an.id_evento = i2.id_evento
                    AND pub.st_aprovado = TRUE
            )
    )
GROUP BY
    p.id_participante,
    p.no_participante
ORDER BY eventos_inscritos DESC;