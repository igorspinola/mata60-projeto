-- Query 14: Eventos com média de publicações por participante maior que 1
-- Objetivo: Mostrar eventos onde, em média, cada participante inscrito tem mais de 1 publicação.
-- Tabelas: evento, inscricao, autoria, anais, publicacao
-- Funções: SUB-CONSULTAS + JOIN + GROUP BY + COUNT
-- Requisito: identificar eventos altamente acadêmicos

  SELECT ev.id_evento, ev.no_evento, t.media_pub_por_inscrito
  FROM tb_evento ev
  JOIN (
      SELECT an.id_evento,
             COUNT(DISTINCT an.id_publicacao)::numeric
           / COUNT(DISTINCT i.id_participante) AS media_pub_por_inscrito
      FROM rl_anais an
      JOIN rl_autoria au ON au.id_publicacao = an.id_publicacao
      JOIN rl_inscricao i ON i.id_evento = an.id_evento
                         AND i.id_participante = au.id_participante
      JOIN tb_publicacao pb ON pb.id_publicacao = an.id_publicacao
      GROUP BY an.id_evento
      HAVING COUNT(DISTINCT an.id_publicacao)::numeric
           / COUNT(DISTINCT i.id_participante) > 1
  ) t ON t.id_evento = ev.id_evento;
