-- vl_preco do evento pra btree, cd_status_pagamento hash
CREATE INDEX idx_tb_evento_vl_preco_btree
ON tb_evento USING BTREE (vl_preco);
CREATE INDEX idx_rl_inscricao_cd_status_pagamento_hash
ON rl_inscricao USING HASH (cd_status_pagamento);

