# MiniSoC AES - primeira etapa simplificada

Escopo: agentes CLOCK/RESET e smoke de inicializacao, com checagem automatica.
O RTL em frontend/rtl permanece inalterado. SPI e memoria ficam ociosos.

## Executar no servidor

Requisitos: Linux, GNU Make, Python 3 e VCS/UVM 1.2 com licenca.
Execute em minisoc-tag-v1.0/verif/tb:

```bash
make test
make wave UVM_TESTNAME=minisoc_clock_reset_test
make verdi
```

`make test` compila e executa smoke e clock_reset com seed 1.
`make wave` compila e gera minisoc.fsdb; o teste padrao e minisoc_smoke_test.
`make verdi` abre a FSDB. Para outro nome, use FSDB_FILE=parte1.fsdb tanto
em make wave quanto em make verdi. FSDB requer integracao VCS/Verdi;
flags adicionais do servidor podem ser passadas em VCS_EXTRA_FLAGS.

Alternativa VCD, sem integracao de dump FSDB:

```bash
make wave_vcd UVM_TESTNAME=minisoc_clock_reset_test
```

Gera stage1.vcd. O dump preserva toda a hierarquia do top/DUT, incluindo
clk_if_inst.clk, reset_if_inst.rst_n, dut.pll_locked, dut.sys_clk,
dut.sys_rst_n e os registradores de configuracao.

Outros comandos preservados:

```bash
make vcs_comp
make vcs_run UVM_TESTNAME=minisoc_smoke_test SEED=1
make regression REG_SEEDS="1 2 3"
```

O verificador de logs exige resumo sem erros/fatais e STAGE1_PASS.
Nao use make clean antes de guardar suas evidencias: ele apaga FSDB e logs.

## Estrutura e responsabilidades

- top_tb.sv: DUT, interfaces, conexoes de observacao, dumps VCD/FSDB e timeout.
- agents/clock_agent e agents/reset_agent: item, sequencer, driver e monitor.
- env/minisoc_env.sv: cria os agentes e conecta monitores ao checker.
- env/minisoc_stage1_checker.sv: centraliza as checagens automaticas.
- sequences/clock_seq.sv e reset_seq.sv: configuram os estimulos.
- tests/: teste base, smoke e teste adicional de resets em idle.

Fluxo: teste -> sequencias -> agentes -> DUT -> monitores -> checker.
Para dois agentes, nao ha objeto de configuracao nem virtual sequencer.
Nao ha modulo separado de assertions nem covergroups nesta versao.
O checker recebe transacoes dos monitores; nao le o DUT diretamente.

## O que e verificado

Clock de referencia de 500 ps, high/low de 250 ps (tolerancia 1 ps),
atividade do clock, reset aplicado/liberado, largura minima observada de
dois ciclos, defaults de controle e bootstrap com PLL desabilitado,
sem lock/sys_clk e AES mantido em reset. Monitores amostram o estado do
DUT 1 ps apos a subida, depois das atualizacoes do RTL.
Ha deteccao de parada do clock e timeout global de 10 us.

Smoke: reset inicial de 8 ciclos, seguido de 32 ciclos de observacao.
Clock/reset: mesmo inicio, mais resets em idle de 2 e 12 ciclos.
O checker exige um ou tres pulsos, conforme o teste.
As duracoes sao escolhas dos testes, nao requisitos gerais do DUT.

Coverage fica planejado para etapas posteriores. Nao se verifica PLL
habilitado, configuracao SPI, memoria ativa nem processamento AES.
Os dois testes sao dirigidos: variar seeds nao amplia seus cenarios.

## Estado das evidencias

Esta simplificacao exige nova execucao no servidor. Logs, waves e resultados
anteriores pertencem a versoes anteriores. Analise estatica local nao
substitui compilacao/simulacao no VCS. Os documentos DOCX da raiz nao foram
alterados e podem descrever a arquitetura anterior.

Validacao local em 28/10/2026: elaboracao estatica com pyslang/UVM 1.2
aprovada (zero erros; dois avisos na biblioteca UVM). Sete testes do
verificador Python de logs aprovados. VCS/Verdi indisponiveis localmente;
nenhuma waveform nova foi gerada nesta maquina.
