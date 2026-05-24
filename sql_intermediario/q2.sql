-- Query 2: Quantidade de coautores por publicação
-- Objetivo: Para cada publicação aprovada, contar quantos autores ela tem (puxando nome e título).
-- Tabelas: publicacao, autoria, participante
-- Funções: JOIN + GROUP BY + COUNT
-- Requisito: identificar publicações colaborativas vs solo

select rl_autoria.id_publicacao, no_titulo, count(id_participante)
from rl_autoria
    join tb_publicacao on tb_publicacao.id_publicacao = rl_autoria.id_publicacao
where
    st_aprovado = true
group by
    rl_autoria.id_publicacao,
    no_titulo
order by rl_autoria.id_publicacao asc;