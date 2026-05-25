-- indexar os campos vl_preco do evento pra hash, cd_status_pagamento hash

CREATE INDEX idx_tb_evento_vl_preco_hash
ON tb_evento USING HASH (vl_preco);
CREATE INDEX idx_rl_inscricao_cd_status_pagamento_hash
ON rl_inscricao USING HASH (cd_status_pagamento);