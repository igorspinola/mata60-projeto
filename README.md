# MATA60 — Banco de Dados

Projeto prático da disciplina **MATA60 - Banco de Dados** (UFBA).  
Modelagem, implementação e consulta de um banco de dados para gerenciamento de eventos científicos.

---

## Sobre o projeto

O sistema gerencia **eventos acadêmicos** e seus dados relacionados: inscrições, pagamentos, publicações nos anais, revisões e autores. O banco foi modelado conceitualmente no BrModelo e implementado em PostgreSQL.

---

## Estrutura do repositório

```
.
├── brmodelo/               # Arquivos do BrModelo (.brM3) e executável
├── sql_ddl/                # Scripts DDL (criação das tabelas)
├── sql_output/             # Scripts de inserção de dados (inserts)
├── sql_intermediario/      # Queries intermediárias (q1 a q10)
├── docker-compose.yml      # Ambiente PostgreSQL + MySQL via Docker
├── BRMODELO_SQL.jpeg       # Modelo conceitual
└── MODELO_LOGICO.jpeg      # Modelo lógico
```

---

## Como executar

### Pré-requisitos

- [Docker](https://www.docker.com/) e Docker Compose instalados

### Subindo o banco

1. Crie um arquivo `.env` na raiz com as variáveis:

```env
DB_NAME=mata60
DB_USER=seu_usuario
DB_PASSWORD=sua_senha
MYSQL_ROOT_PASSWORD=sua_senha_root
```

2. Suba os containers:

```bash
docker compose up -d
```

O Docker irá inicializar o banco automaticamente com o DDL e os inserts.

---

## Queries intermediárias

As queries estão em `sql_intermediario/` e cobrem consultas com 3+ tabelas usando `JOIN`, `GROUP BY`, `COUNT` e `WINDOW FUNCTIONS`:

| Arquivo | Descrição |
|---|---|
| `q1.sql` | Eventos com mais publicações nos anais |
| `q2.sql` | Quantidade de coautores por publicação |
| `q3.sql` | Participantes que são também autores |
| `q4.sql` | Distribuição de status de pagamento por evento |
| `q5.sql` | Publicações por tipo em cada evento |
| `q6.sql` | Eventos com 100% das inscrições pagas |
| `q7.sql` | Carga de revisão por revisor |
| `q8.sql` | Eventos com publicação aprovada e apresentada |
| `q9.sql` | Receita arrecadada por método de pagamento |
| `q10.sql` | Ranking de eventos por receita com `RANK()` |

---

## Contribuintes

| Nome | GitHub |
|---|---|
| Deivid Costa | [@ynxdeiv](https://github.com/ynxdeiv) |
| Igor Spinola | [@igorspinola](https://github.com/igorspinola) |
| Douglas Aleixo | [@douglas-aleixo](https://github.com/douglas-aleixo) |
| Pedro Larchert | [@PedroLarchert](https://github.com/PedroLarchert) |
