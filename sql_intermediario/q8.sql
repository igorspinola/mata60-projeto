-- Query 8: Eventos com publicação aprovada e apresentada
-- Objetivo: Para cada evento, contar quantas publicações foram aprovadas E apresentadas.
-- Tabelas: evento, anais, publicacao
-- Funções: JOIN + GROUP BY + COUNT
-- Requisito: medir efetividade dos eventos (aprovado != necessariamente apresentado)

select tb_evento.no_evento, count(*)
from
    tb_evento
    join rl_anais on rl_anais.id_evento = tb_evento.id_evento
    join tb_publicacao on tb_publicacao.id_publicacao = rl_anais.id_publicacao
WHERE
    tb_publicacao.st_aprovado = true
    and tb_publicacao.st_apresentacao = true
group by
    tb_evento.no_evento
order by tb_evento.no_evento ASC;