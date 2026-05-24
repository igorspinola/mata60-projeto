-- Query 5: Ranking de publicações pelo número de coautores
-- Objetivo: Mostrar todas as publicações aprovadas com o número de coautores e a posição no ranking.
-- Tabelas: publicacao, autoria, participante
-- Funções: JOIN + GROUP BY + COUNT + WINDOW (RANK)
-- Requisito: identificar publicações mais colaborativas

select tb_publicacao.id_publicacao, tb_publicacao.no_titulo, count(rl_autoria.id_participante) as qt_coautores, rank() over (
        order by count(rl_autoria.id_participante) desc
    ) as posicao
from
    tb_publicacao
    join rl_autoria on rl_autoria.id_publicacao = tb_publicacao.id_publicacao
    join tb_participante on tb_participante.id_participante = rl_autoria.id_participante
where
    tb_publicacao.st_aprovado = true
group by
    tb_publicacao.id_publicacao,
    tb_publicacao.no_titulo
order by posicao, tb_publicacao.id_publicacao;