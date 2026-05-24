-- Query 3: Participantes que são também autores
-- Objetivo: Listar participantes inscritos em eventos que também publicaram algum artigo.
-- Tabelas: participante, inscricao, autoria
-- Funções: JOIN + GROUP BY + COUNT
-- Requisito: identificar participantes-pesquisadores ativos

select tb_participante.id_participante, no_participante
from tb_participante
    join rl_autoria on rl_autoria.id_participante = tb_participante.id_participante
group by
    tb_participante.id_participante
order by tb_participante.id_participante;

-- alternativa com DISTINCT:
-- select distinct(tb_participante.id_participante), no_participante from tb_participante
-- join rl_autoria on rl_autoria.id_participante = tb_participante.id_participante
-- order by tb_participante.id_participante asc;