-- Query 18: Top 3 autores mais publicados em cada evento
-- Objetivo: Para cada evento, mostrar os 3 autores com mais publicações aprovadas.
-- Tabelas: evento, anais, publicacao, autoria, participante
-- Funções: JOIN + GROUP BY + WINDOW (ROW_NUMBER com PARTITION) + COUNT
-- Requisito: destaque de autores por evento
select
    id_evento,
    id_participante,
    no_participante
from (
        select
            id_evento, id_participante, no_participante, count(id_publicacao) as tot_publi_evento, row_number() over (
                partition by
                    id_evento
                order by count(id_publicacao) desc
            ) as posicao
        from (
                select rl_anais.id_evento, tb_participante.id_participante, no_participante, rl_anais.id_publicacao
                from
                    rl_anais
                    join rl_autoria on rl_autoria.id_publicacao = rl_anais.id_publicacao
                    join tb_participante on tb_participante.id_participante = rl_autoria.id_participante
                group by
                    id_evento, tb_participante.id_participante, rl_anais.id_publicacao
            )
        group by
            id_evento, id_participante, no_participante
    )
where
    posicao <= 3
order by id_evento asc