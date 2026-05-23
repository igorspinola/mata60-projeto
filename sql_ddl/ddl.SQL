CREATE TABLE tb_evento (
id_evento INTEGER,
vl_preco DECIMAL(10,2) NOT NULL,
qt_vagas INTEGER NOT NULL,
dh_fim TIMESTAMP NOT NULL,
dh_inicio TIMESTAMP NOT NULL,
ds_local VARCHAR(200) NOT NULL,
no_evento VARCHAR(100) NOT NULL,
PRIMARY KEY (id_evento)
);

CREATE TABLE tb_participante (
id_participante INTEGER PRIMARY KEY,
nu_cpf VARCHAR(11) UNIQUE NOT NULL,
no_participante VARCHAR(100) NOT NULL,
ds_email VARCHAR(150) UNIQUE NOT NULL
);

CREATE TABLE rl_inscricao (
nu_inscricao INTEGER UNIQUE NOT NULL,
id_participante INTEGER NOT NULL,
ds_metodo_pagamento VARCHAR(50) NOT NULL,
dh_pagamento TIMESTAMP,
cd_status_pagamento INTEGER NOT NULL,
id_evento INTEGER NOT NULL,
PRIMARY KEY (nu_inscricao, id_participante, id_evento)
);

CREATE TABLE tb_publicacao (
id_publicacao INTEGER PRIMARY KEY,
dh_atualizacao TIMESTAMP,
st_aprovado BOOLEAN NOT NULL,
dh_criacao TIMESTAMP NOT NULL,
no_titulo VARCHAR(200) NOT NULL,
tx_conteudo TEXT NOT NULL,
st_apresentacao BOOLEAN NOT NULL,
cd_tipo_publicacao INTEGER NOT NULL
);

CREATE TABLE tb_tipo_publicacao (
id_tipo_publicacao INTEGER PRIMARY KEY,
no_tipo_publicacao VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE rl_anais (
id_evento INTEGER NOT NULL,
id_publicacao INTEGER NOT NULL,
PRIMARY KEY (id_evento, id_publicacao)
);

CREATE TABLE rl_autoria (
id_participante INTEGER NOT NULL,
id_publicacao INTEGER NOT NULL,
PRIMARY KEY (id_participante, id_publicacao)
);

CREATE TABLE tb_revisor (
id_revisor INTEGER PRIMARY KEY,
no_revisor VARCHAR(100) NOT NULL,
nu_cpf VARCHAR(11) UNIQUE NOT NULL
);

CREATE TABLE rl_revisao (
id_publicacao INTEGER NOT NULL,
id_revisor INTEGER NOT NULL,
st_aprovado BOOLEAN NOT NULL,
dt_revisao DATE NOT NULL,
PRIMARY KEY (id_publicacao, id_revisor)
);

CREATE TABLE tb_status_pagamento (
id_pagamento INTEGER PRIMARY KEY,
no_status_pagamento VARCHAR(30) UNIQUE NOT NULL
);

ALTER TABLE rl_inscricao ADD CONSTRAINT FK_rl_inscricao_id_evento
FOREIGN KEY (id_evento)
REFERENCES tb_evento (id_evento);

ALTER TABLE rl_inscricao ADD CONSTRAINT FK_rl_inscricao_id_participante
FOREIGN KEY (id_participante)
REFERENCES tb_participante (id_participante);

ALTER TABLE rl_inscricao ADD CONSTRAINT FK_rl_inscricao_status_pagamento
FOREIGN KEY (cd_status_pagamento)
REFERENCES tb_status_pagamento (id_pagamento);

ALTER TABLE tb_publicacao ADD CONSTRAINT FK_tb_publicacao_tipo_publicacao
FOREIGN KEY (cd_tipo_publicacao)
REFERENCES tb_tipo_publicacao (id_tipo_publicacao);

ALTER TABLE rl_anais ADD CONSTRAINT FK_rl_anais_id_evento
FOREIGN KEY (id_evento)
REFERENCES tb_evento (id_evento);

ALTER TABLE rl_anais ADD CONSTRAINT FK_rl_anais_id_publicacao
FOREIGN KEY (id_publicacao)
REFERENCES tb_publicacao (id_publicacao);

ALTER TABLE rl_autoria ADD CONSTRAINT FK_rl_autoria_participante
FOREIGN KEY (id_participante)
REFERENCES tb_participante (id_participante);

ALTER TABLE rl_autoria ADD CONSTRAINT FK_rl_autoria_publicacao
FOREIGN KEY (id_publicacao)
REFERENCES tb_publicacao (id_publicacao);

ALTER TABLE rl_revisao ADD CONSTRAINT FK_rl_revisao_publicacao
FOREIGN KEY (id_publicacao)
REFERENCES tb_publicacao (id_publicacao);

ALTER TABLE rl_revisao ADD CONSTRAINT FK_rl_revisao_revisao
FOREIGN KEY (id_revisor)
REFERENCES tb_revisor (id_revisor);
