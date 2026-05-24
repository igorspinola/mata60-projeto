-- Query 13: Participantes inscritos no evento mais caro
-- Objetivo: Listar nome e email dos participantes inscritos no evento de maior preço.
-- Tabelas: participante, inscricao, evento
-- Funções: SUB-CONSULTAS + JOIN
-- Requisito: identificar público de alto valor

  SELECT p.no_participante, p.ds_email, COUNT(i.nu_inscricao) AS qtd_inscricoes
  FROM rl_inscricao AS i
  JOIN tb_participante AS p ON i.id_participante = p.id_participante
  WHERE i.id_evento IN (
      SELECT id_evento FROM tb_evento
      WHERE vl_preco = (SELECT MAX(vl_preco) FROM tb_evento)
  )
  GROUP BY p.no_participante, p.ds_email
  ORDER BY qtd_inscricoes DESC;
