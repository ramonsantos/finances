# Manual de funcionalidades — Finanças

Aplicação pessoal para registrar **despesas**, gerar **relatório mensal**, **importar CSV** (formato da aba de gastos) e controlar **empréstimos**. Não há login: quem acessa a URL usa o sistema.

## Navegação

Na barra lateral (telas largas): lista de despesas, relatório, importação, categorias de despesa, formas de pagamento e empréstimos. Em telas pequenas, o menu reduzido mostra só despesas e empréstimos.

## Interface comum (listagens)

Nas telas de **despesas**, **categorias** e **formas de pagamento**:

- **Criar** e **editar** abrem **modais** na própria listagem (não há páginas separadas de “nova” ou “editar”).
- **Esc** ou **Cancelar** fecham o modal; em confirmações de exclusão, **Esc** também cancela.
- Formulários usam **um campo por linha**; valores monetários com máscara **R$**; categorias e formas de pagamento com campo **pesquisável** (digitar para filtrar, seta para abrir lista, clique para escolher); essencial e fixo com **interruptor** (toggle).

**Exclusão de despesa:** só na **lista mensal** (não aparece no modal de edição). Categorias e formas de pagamento seguem a mesma regra de exclusão na listagem, com confirmação em modal.

A lista de despesas tem cabeçalho com **mês anterior | mês atual | próximo mês** centralizado na tela, alternância **Lista / Relatório** (botão verde) e **Nova despesa** (botão azul). O relatório permite **Nova despesa** no mesmo padrão de modal. Ações principais (salvar, criar, foco de campos, interruptores) usam **azul**; a troca lista/relatório usa **verde**.

## Despesa (campos da planilha)

Cada lançamento segue as colunas **A–H** da planilha de gastos:

| Campo | Obrigatório | Regra |
|-------|-------------|--------|
| Data | Sim | Dia do gasto |
| Descrição | Sim | Texto livre |
| Valor | Sim | Mínimo R$ 0,01 |
| Categoria | Sim | Deve existir no cadastro |
| Forma de pagamento | Sim | Deve existir no cadastro (menu Formas de pagamento) |
| Essencial? | Sim | Marca se o gasto é essencial |
| Fixo? | Sim | Indica despesa fixa (recorrente no mês) |
| Observação | Não | Texto curto (uma linha) |

Na lista mensal você vê o total do mês e pode mudar de mês pelos atalhos. Essencial e Fixo aparecem como **Sim** ou **Não**.

## Categorias de despesa

Em **Categorias** você cria, edita (modal) e exclui categorias na listagem. Nome é único (ignora maiúsculas). Não é possível excluir categoria com despesas vinculadas.

## Formas de pagamento

Em **Formas de pagamento** você cadastra, edita (modal) e exclui meios usados nas despesas e na importação CSV (ex.: Cartão Nubank, Pix Santander). Nome único; não é possível excluir forma com despesas vinculadas.

Cadastre categorias e formas **antes** de lançar despesas ou importar CSV. O `db:seed` não é obrigatório.

## Importação de planilha

Em **Importar despesas** envie um arquivo **CSV** exportado da aba de gastos (mesmos cabeçalhos da planilha). O CSV não tem abas: uma única tabela com essas colunas.

**O que entra na importação:** apenas colunas com estes cabeçalhos: Data, Descrição, Valor, Categoria, Forma de pagamento, Essencial?, Fixo?, Observação.

**O que não importa:** totais, “Fontes”, “Atualizado em”, contadores laterais e qualquer coluna à direita da área de lançamentos na planilha original — o sistema ignora colunas extras.

**Comportamento por linha:**

- Linha sem data ou sem valor é **ignorada** (não gera erro).
- Linha com dados inválidos gera registro de **erro** na página do resultado.
- Essencial? e Fixo? aceitam `sim` ou `não` (com ou sem acento).
- Datas: `dd/mm/aaaa` ou `dd/mm/aa`.

O processamento roda em segundo plano (fila Solid Queue). Em desenvolvimento use `bin/dev` ou Docker com o processo de jobs ativo.

Baixe o **modelo CSV** na mesma tela para conferir os cabeçalhos.

## Relatório mensal

Mostra o **total do mês**, a participação de cada **categoria** (valor e %) e uma tabela por **forma de pagamento** (quantidade de lançamentos, total e %). É a visão analítica equivalente ao uso da planilha, calculada a partir dos dados gravados no app.

## Empréstimos

Cadastro de valores emprestados e recebidos em **páginas dedicadas** (novo e editar na tela), com listas “em aberto” e “recebidos” e totais a receber.

## Dados e backup

SQLite em `storage/`. Em produção o projeto documenta backup via `bin/backup` para um segundo disco — ver [README.md](README.md).