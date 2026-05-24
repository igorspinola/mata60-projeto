-- Query 1: Eventos com mais publicações nos anais
-- Objetivo: Listar eventos rankeados pela quantidade de publicações que entraram nos anais.
-- Tabelas: evento, anais, publicacao
-- Funções: JOIN + GROUP BY + COUNT
-- Requisito: medir produção científica gerada por cada evento

select tb_evento.id_evento, tb_evento.no_evento, count(id_publicacao) as tot_publi
from rl_anais
    join tb_evento on tb_evento.id_evento = rl_anais.id_evento
group by
    tb_evento.id_evento,
    tb_evento.no_evento
order by tot_publi desc;