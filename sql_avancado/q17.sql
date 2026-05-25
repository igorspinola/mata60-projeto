-- Query 17: Publicações cujo autor também é revisor (conflito de interesse)
-- Objetivo: Detectar casos onde um autor aparece como revisor (mesmo CPF) no sistema.
-- Tabelas: participante, autoria, publicacao, revisao, revisor
-- Funções: SUB-CONSULTAS + JOIN + GROUP BY
-- Requisito: detectar potencial conflito de interesse

SELECT pb.id_publicacao,
       pb.no_titulo,
       p.no_participante AS autor_em_conflito,
       p.nu_cpf,
       COUNT(*) AS qtd_revisoes_proprias
FROM tb_publicacao pb
JOIN rl_autoria au     ON au.id_publicacao = pb.id_publicacao
JOIN tb_participante p ON p.id_participante = au.id_participante
JOIN (
    SELECT rv.id_publicacao, r.nu_cpf
    FROM rl_revisao rv
    JOIN tb_revisor r ON r.id_revisor = rv.id_revisor
) AS revisores_da_pub
       ON revisores_da_pub.id_publicacao = pb.id_publicacao
      AND revisores_da_pub.nu_cpf = p.nu_cpf
GROUP BY pb.id_publicacao, pb.no_titulo, p.no_participante, p.nu_cpf
ORDER BY qtd_revisoes_proprias DESC;
