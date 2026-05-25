-- Query 15: Revisores com taxa de aprovação acima da média geral
-- Objetivo: Calcular taxa de aprovação de cada revisor e mostrar os que estão acima da média.
-- Tabelas: revisor, revisao, publicacao
-- Funções: SUB-CONSULTAS + JOIN + GROUP BY + COUNT
-- Requisito: identificar revisores mais permissivos que o normal

SELECT rv.id_revisor,
       rv.no_revisor,
       COUNT(*) AS qtd_revisoes,
       ROUND(COUNT(*) FILTER (WHERE r.st_aprovado)::numeric / COUNT(*), 4) AS taxa_aprovacao
FROM tb_revisor rv
JOIN rl_revisao r   ON r.id_revisor = rv.id_revisor
JOIN tb_publicacao p ON p.id_publicacao = r.id_publicacao
GROUP BY rv.id_revisor, rv.no_revisor
HAVING COUNT(*) FILTER (WHERE r.st_aprovado)::numeric / COUNT(*) > (
    SELECT COUNT(*) FILTER (WHERE st_aprovado)::numeric / COUNT(*)
    FROM rl_revisao
)
ORDER BY taxa_aprovacao DESC;
