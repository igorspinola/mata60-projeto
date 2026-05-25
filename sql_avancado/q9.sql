-- Query 9: Autores com publicação aprovada em 2+ tipos diferentes
-- Objetivo: Listar autores que têm publicações aprovadas em mais de um tipo (ex: Artigo E Resumo).
-- Tabelas: participante, autoria, publicacao, tipo_publicacao
-- Funções: JOIN + GROUP BY + COUNT (DISTINCT) + HAVING
-- Requisito: identificar pesquisadores versáteis

SELECT
    p.id_participante,
    p.no_participante,
    COUNT(DISTINCT pub.cd_tipo_publicacao) AS qt_tipos_distintos,
    STRING_AGG(DISTINCT tp.no_tipo_publicacao, ', ') AS tipos_publicados
FROM tb_participante p
JOIN rl_autoria rau ON p.id_participante = rau.id_participante
JOIN tb_publicacao pub ON rau.id_publicacao = pub.id_publicacao
JOIN tb_tipo_publicacao tp ON pub.cd_tipo_publicacao = tp.id_tipo_publicacao
WHERE pub.st_aprovado = TRUE
GROUP BY p.id_participante, p.no_participante
HAVING COUNT(DISTINCT pub.cd_tipo_publicacao) >= 2
ORDER BY qt_tipos_distintos DESC;