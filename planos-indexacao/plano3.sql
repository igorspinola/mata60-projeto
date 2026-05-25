-- nu_cpf do revisor e participante pra hash 
CREATE INDEX idx_tb_participante_cpf_hash
ON tb_participante USING HASH (nu_cpf);
CREATE INDEX idx_tb_revisor_cpf_hash
ON tb_revisor USING HASH (nu_cpf); 
