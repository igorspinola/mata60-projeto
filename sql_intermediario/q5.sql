-- Query 5: Publicações por tipo em cada evento
-- Objetivo: Quantos Artigos e Resumos cada evento publicou nos anais.
-- Tabelas: evento, anais, publicacao, tipo_publicacao
-- Funções: JOIN + GROUP BY + COUNT
-- Requisito: caracterização do perfil de publicações de cada evento

select tb_evento.no_evento, tb_tipo_publicacao.no_tipo_publicacao, COUNT(*) as total
from
    tb_evento
    INNER JOIN rl_anais on tb_evento.id_evento = rl_anais.id_evento
    INNER JOIN tb_publicacao on tb_publicacao.id_publicacao = rl_anais.id_publicacao
    INNER JOIN tb_tipo_publicacao on tb_publicacao.cd_tipo_publicacao = tb_tipo_publicacao.id_tipo_publicacao
group by
    tb_evento.no_evento,
    tb_tipo_publicacao.no_tipo_publicacao
order by total DESC;