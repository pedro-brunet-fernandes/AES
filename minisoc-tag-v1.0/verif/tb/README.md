# MiniSoC AES parte 1

Este guia valida somente o bootstrap de clock/reset do MiniSoC AES. O VCS
executa checagens e coleta cobertura; o Verdi permite analisar assertions,
covergroups, codigo e waves. Nao ha processamento AES nesta campanha.

## 1. Atualizar os arquivos e preparar o servidor

Leve a versao atual de verif/tb ao servidor pelo fluxo habitual de transferencia
ou commit/push/pull. Nao reutilize o simv anterior como evidencia desta revisao.
No servidor utilizado neste projeto:

```bash
source /Tools/synopsys-scripts/snps.sh
cd /home/pedro.brunet/proj/minisoc-tag-v1.0/verif/tb
command -v vcs
command -v verdi
command -v urg
command -v python3
```

O caminho acima e o registrado no log enviado pelo usuario; ajuste se o clone
for outro. A campanha anterior utilizou VCS/Verdi X-2025.06-SP2 e UVM 1.2.
Registre a versao real desta campanha no log de compilacao e a identificacao
dos fontes. Em clone Git, registre `git rev-parse HEAD` e `git status --short`;
se houver alteracoes locais, guarde tambem o diff. Nao atribua um hash a uma
pasta extraida de ZIP sem verificar sua origem.

## 2. Compilar e executar com coverage

Escolha uma base nova por campanha, para evitar misturar resultados antigos.
Abaixo, parte1_campanha01 e um nome de exemplo; use campanha02 na proxima
campanha, em todos os comandos correspondentes.

```bash
make stage1_cov SEED=1 COV_DIR=coverage/parte1_campanha01.vdb
```

Este alvo recompila RTL e TB com instrumentacao, usando simv_cov/csrc_cov,
e roda os dois testes. A estrutura Makefile -> Makefile.top -> Makefile.common
permanece. Nao e necessario selecionar outro perfil no Makefile.

| Teste | Estimulo | Resultado esperado |
|---|---|---|
| minisoc_smoke_test | Reset inicial de 8 ciclos; mais 32 ciclos | Um pulso, clock valido, defaults e bootstrap corretos |
| minisoc_clock_reset_test | Reset de 8 ciclos; resets idle de 2 e 12 ciclos | Tres pulsos; todos os bins funcionais da parte 1 atingidos |

Verifique os arquivos:

- vcs_logger.log: compilacao/elaboracao sem erro.
- logs/minisoc_smoke_test_1.log: STAGE1_PASS e resumo limpo.
- logs/minisoc_clock_reset_test_1.log: STAGE1_PASS e resumo limpo.

Os dois logs devem terminar com UVM_ERROR=0 e UVM_FATAL=0. Investigue warnings.
O verificador Python e executado automaticamente e rejeita logs incompletos.
No clock/reset, espere a mensagem STAGE1_COVERAGE com clock=100.00% e
reset=100.00%. Um gap gera STAGE1_COVERAGE_GAP e impede PASS.
No smoke, a cobertura de reset sera parcial: ele nao aplica os resets idle.
Isso e esperado e nao reprova o smoke.

Se a compilacao falhar, pare e leia o primeiro erro em vcs_logger.log.
Nao execute um simv_cov antigo para contornar uma compilacao que falhou.
As novas assertions/covergroups ainda precisam dessa validacao no servidor;
nao foram executadas localmente por ausencia de VCS.

## 3. Executar a regressao

```bash
make regression_cov REG_SEEDS="1 2 3" COV_DIR=coverage/parte1_campanha01.vdb
```

Sao seis runs, com registro de coverage separado por teste/seed, na mesma
base. O loop para na primeira falha. Os logs ficam em logs/<teste>_<seed>.log.
Repetir teste/seed usa o mesmo nome de registro: nao conte essa repeticao
como novo cenario. Copie logs para o arquivo de evidencias antes de outra campanha.
Os estimulos sao dirigidos; seeds adicionais verificam repetibilidade, sem
prometer diversidade funcional. Os runs de seed 1 tambem repetem a etapa 2.

## 4. Gerar relatorio e abrir coverage no Verdi

```bash
make coverage_report COV_DIR=coverage/parte1_campanha01.vdb COV_REPORT=coverage/relatorio_campanha01
make verdi_cov COV_DIR=coverage/parte1_campanha01.vdb
```

URG gera o relatorio em coverage/relatorio_campanha01. Abra o HTML de entrada
produzido pela versao instalada. O Verdi abre a base VDB, que e diferente do
FSDB de waves. Regerar o relatorio depois de novas simulacoes.

### Groups ou Functional Coverage

Localize os covergroups do minisoc_stage1_checker:

| Grupo/ponto | Bins esperados nesta campanha |
|---|---|
| stage1_clock_cg.cp_nominal | nominal_2ghz |
| stage1_reset_cg.cp_context | initial_boot, idle_reassertion |
| stage1_reset_cg.cp_width | short_reset=2, boot_reset=8, long_reset=12 |
| stage1_reset_cg.cp_recovery | defaults_restored |

A meta e 100% desses bins no teste clock/reset. Os eventos de reset sao
amostrados na primeira subida observada depois da liberacao, usando o numero
de amostras baixas contado pelo monitor. O checker compara tambem a ordem
e as larguras exatas 8, 2 e 12; hits isolados nao substituem essa checagem.
Os bins de duracao representam escolhas da suite, nao requisitos universais do DUT.
Contexto idle e identificado pela ordem dos pulsos, valida somente neste TB
sem trafego e com PLL desabilitado. Nao ha bin de reset durante AES ativo.

### Asserts ou Assertions

Localize top_tb.assertions_i. As seis assertions concorrentes sao:

| Assertion | Verificacao |
|---|---|
| a_reset_known | rst_n nao e X/Z |
| a_control_defaults | Defaults permanecem corretos no cenario idle |
| a_pll_disabled | PLL permanece desabilitado no escopo da parte 1 |
| a_no_lock_disabled | Sem enable, nao ha lock |
| a_no_sys_clk_unlocked | Sem lock, sys_clk esta baixo na amostra |
| a_aes_reset_disabled | Sem enable, reset interno permanece ativo |

Todas sao amostradas na descida do clock de referencia, quando os efeitos da
subida anterior estao estabilizados. Sao verificacoes do cenario de bootstrap;
nao demonstram ausencia de glitches entre amostras, PLL habilitado ou AES ativo.
A assertion imediata a_control_reset permanece e verifica defaults 1 ps apos
a subida durante reset. Seu registro na interface de coverage pode diferir
das assertions concorrentes; suas falhas sempre geram A_CONTROL_RESET no log.

Exija zero falhas e tentativas/exercicio das assertions concorrentes. Confira
hits nas cover properties c_reset_low, c_reset_high e c_disabled_bootstrap.
Elas demonstram que as condicoes relevantes ocorreram; nao conte apenas
sucessos vacuos de implicacoes. Todas as tres devem ter hits nos testes.
Se a ferramenta mostrar somente o fonte, confirme que abriu a VDB da campanha
instrumentada. FSDB sozinho nao substitui os dados de coverage.

### Hierarchy ou Code Coverage

Inspecione line, condition, branch, toggle e FSM, conforme suporte da versao.
A coleta inclui o DUT completo; a interpretacao e restrita ao bootstrap.
Registre os trechos exercitados em minisoc_top, minisoc_spi e minisoc_pll_mock.
Ramos de PLL habilitado, operacoes SPI, RAM e AES ficarao sem cobertura.
Nao exija 100% do DUT inteiro e nao exclua esses trechos permanentemente:
registre-os como fora do escopo desta campanha e pendentes para as proximas partes.
Ausencia de cobertura de FSM ou de um ramo nao significa falha automaticamente.
Percentual global nao substitui os bins funcionais nem a analise de assertions.

## 5. Gerar e inspecionar waves da versao nova

Depois da compilacao com coverage, execute:

```bash
make vcs_fsdb_run COVERAGE=1 UVM_TESTNAME=minisoc_clock_reset_test SEED=10 COV_DIR=coverage/parte1_campanha01.vdb FSDB_FILE=parte1_clock_reset.fsdb
make verdi_wf FSDB_FILE=parte1_clock_reset.fsdb
```

Seed 10 separa esse registro das seis runs da regressao. Este alvo de execucao
nao recompila; use o simv_cov produzido pela etapa 2 ou 3, com a mesma base.
O log e vcs_fsdb_run.log. O servidor ja demonstrou integracao FSDB/Verdi;
se a instalacao mudar, confira o setup/PLI local.

Adicione clk_if_inst.clk e, em reset_if_inst, rst_n, control_defaults_ok,
pll_enable, pll_locked, sys_clk e sys_rst_n.

| Observacao | Esperado |
|---|---|
| Clock de referencia | Periodo 500 ps; alto/baixo 250 ps; tolerancia 1 ps no checker |
| Reset inicial | Baixo de 0 a 4 ns |
| Segundo reset | Baixo de 12 a 13 ns |
| Terceiro reset | Baixo de 25 a 31 ns |
| Controle | Defaults corretos apos inicializacao |
| PLL e sistema | enable=0, locked=0, sys_clk=0, sys_rst_n=0 |
| Fim do teste clock/reset | Aproximadamente 43 ns |

Um transitorio X na inicializacao em tempo zero pode aparecer antes da
primeira amostra. X persistente apos a inicializacao deve reprovar as checagens.
Nao exija RAM, saidas AES ou mem_o_data zerados: o AES usa reset sincrono e
seu clock permanece parado; a memoria nao e apagada pelo reset global.
Capture toda a simulacao e um detalhe do periodo do clock. Posicione o cursor
apos a inicializacao para a coluna de valores nao mostrar o estado de tempo zero.

## 6. Criterio de conclusao da parte 1

- Compilacao nova bem-sucedida, com versao dos fontes registrada.
- Dois testes e seis runs da regressao sem erros/fatais.
- Assertions concorrentes exercitadas e sem falhas; tres cover properties com hits.
- Todos os bins funcionais definidos acima atingidos no clock/reset.
- Code coverage analisado, com lacunas fora do escopo explicadas.
- Logs, FSDB, VDB, relatorio URG e capturas preservados.

O PASS e a meta de 100% referem-se somente aos bins de bootstrap da parte 1.
F01/F02 do VPLAN permanecem parcialmente verificadas: reset em operacao,
PLL habilitado/lock/divisores e recuperacao funcional ainda dependem de outras etapas.
Nenhuma mudanca no RTL ou VIP SPI/MEMORY/refmodel AES e necessaria aqui.

## 7. Reproduzir falhas e preservar resultados

Para reproduzir um teste especifico instrumentado:

```bash
make vcs_run COVERAGE=1 UVM_TESTNAME=minisoc_clock_reset_test SEED=2 COV_DIR=coverage/parte1_campanha01.vdb RUN_LOG=repro_clock_reset_2.log
```

Use a mesma versao dos fontes e do binario. Procure o primeiro erro, sobretudo
CLK_PERIOD, RST_EXACT_WIDTH, STAGE1_COVERAGE_GAP e os IDs A_*.
Falha de licenca ou ferramenta e falha de infraestrutura, nao prova de bug RTL.
Se Verdi Coverage nao tiver licenca, tente o relatorio URG conforme licenca
local e registre a limitacao; nao declare coverage analisado sem evidencias.

O alvo clean remove logs e executaveis, mas preserva coverage/. Arquive tudo
antes de limpar. Guarde as capturas e bases fora de arquivos de fonte; nao envie
executaveis e bases grandes por commit sem necessidade.
