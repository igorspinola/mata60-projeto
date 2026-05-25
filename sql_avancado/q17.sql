-- Query 17: Parcerias frequentes de coautoria (CPFs que coautoram >1 publicação)
-- Objetivo: Identificar pares de pesquisadores (identificados por CPF) que
--           coautoraram em mais de uma publicação — possíveis grupos de pesquisa.
-- Tabelas: participante, autoria, publicacao
-- Funções: SUB-CONSULTAS + JOIN (self-join) + GROUP BY + COUNT
-- Requisito: detectar parcerias acadêmicas recorrentes
-- Indexável: todos os joins usam PK/FK (id_publicacao, id_participante);
--            nu_cpf exibido tem índice UNIQUE em tb_participante.
-- Truque: au1.id_participante < au2.id_participante evita pares duplicados
--         (A,B) e (B,A) e também impede par com a própria pessoa.

SELECT p1.no_participante AS pesquisador_1,
       p1.nu_cpf          AS cpf_1,
       p2.no_participante AS pesquisador_2,
       p2.nu_cpf          AS cpf_2,
       COUNT(DISTINCT pb.id_publicacao) AS qtd_coautorias
FROM rl_autoria au1
JOIN rl_autoria au2     ON au1.id_publicacao   = au2.id_publicacao
                       AND au1.id_participante < au2.id_participante
JOIN tb_participante p1 ON p1.id_participante  = au1.id_participante
JOIN tb_participante p2 ON p2.id_participante  = au2.id_participante
JOIN tb_publicacao pb   ON pb.id_publicacao    = au1.id_publicacao
WHERE pb.id_publicacao IN (
    SELECT id_publicacao
    FROM rl_autoria
    GROUP BY id_publicacao
    HAVING COUNT(*) > 1
)
GROUP BY p1.no_participante, p1.nu_cpf, p2.no_participante, p2.nu_cpf
HAVING COUNT(DISTINCT pb.id_publicacao) > 1
ORDER BY qtd_coautorias DESC;
