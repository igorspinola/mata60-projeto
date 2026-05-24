-- Query 6: Revisores que NUNCA reprovaram nenhuma publicação
-- Objetivo: Listar revisores cujo st_aprovado em todas as revisões é TRUE.
-- Tabelas: revisor, revisao, publicacao
-- Funções: SUB-CONSULTAS + JOIN + GROUP BY (com HAVING) + COUNT
-- Requisito: detectar possível leniência na revisão
select tb_revisor.no_revisor, count(rl_revisao.id_publicacao) as total_revisao
from
    tb_revisor
    left join rl_revisao on rl_revisao.id_revisor = tb_revisor.id_revisor
    left join tb_publicacao on tb_publicacao.id_publicacao = rl_revisao.id_publicacao
where
    tb_revisor.id_revisor not in(
        select id_revisor
        from rl_revisao
        where
            rl_revisao.st_aprovado = false
    )
group by
    tb_revisor.no_revisor
having
    count(rl_revisao.id_publicacao) > 0