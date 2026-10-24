# MiniSoC AES primeira etapa

Ambiente UVM 1.2 limitado a CLOCK, RESET e bootstrap do controle.

## Executar no servidor

Requisitos: Linux, GNU Make, VCS/UVM 1.2 com licenca e Python 3.

```bash
cd minisoc-tag-v1.0/verif/tb
make stage1 SEED=1
```

Mantida a estrutura Makefile -> Makefile.top -> Makefile.common.
Para usar o perfil clock/reset, selecionar Makefile.clock_reset no Makefile
ou fornecer UVM_TESTNAME na linha de comando.

```bash
make vcs_comp
make vcs_run UVM_TESTNAME=minisoc_smoke_test SEED=1
make vcs_run UVM_TESTNAME=minisoc_clock_reset_test SEED=1
make regression REG_SEEDS="1 2 3"
```

make/all compilam. stage1 compila e executa os dois testes, com logs separados
em logs/. O script de logs rejeita erros UVM, resumos incompletos e ausencia de
STAGE1_PASS. O marcador corresponde somente ao bootstrap clock/reset.

## Arquivos para apresentar

```text
verif/tb/
  Makefile, Makefile.common, Makefile.top, Makefile.clock_reset
  top_tb.sv
  top_assertions.sv
  agents/
    clock_agent/  interface, item, sequencer, driver, monitor e package
    reset_agent/  interface, item, sequencer, driver, monitor e package
  env/
    minisoc_env_cfg.sv
    minisoc_virtual_sequencer.sv
    minisoc_stage1_checker.sv
    minisoc_env.sv
    minisoc_env_pkg.sv
  sequences/
    clock_seq.sv
    reset_seq.sv
    minisoc_smoke_vseq.sv
  tests/
    minisoc_base_test.sv
    minisoc_smoke_test.sv
    minisoc_clock_reset_test.sv
    minisoc_test_pkg.sv
  scripts/
    check_stage1_log.py
  refmod/         pasta reservada, sem modelo nesta etapa
```

Outras pastas originais foram preservadas. .gitkeep/.empty apenas mantem pastas
vazias; nao e fonte compilado. O arquivo original proj.7z foi preservado e contem os modelos retirados.
Os artefatos antigos nao representam evidencias desta versao.

## Fluxo implementado

1. top_tb instancia DUT e interfaces CLOCK/RESET e publica virtual interfaces.
2. O teste cria env e executa a virtual sequence.
3. clock_seq configura o gerador continuo do driver em 2 GHz.
4. reset_seq solicita reset; o driver o libera na borda de descida do clock.
5. Monitores observam clock/reset e publicam transacoes para o checker.
6. O checker valida temporizacao, valores iniciais do controle e contagens.
7. O teste encerra e informa PASS/FAIL; o Make confere o log.

O driver CLOCK e o unico gerador da referencia; um comando inicia a geracao
continua, sem suporte adicional a pausa/reconfiguracao nesta etapa.
A interface inicia rst_n=1 para que o driver crie uma borda real de reset em
tempo zero, inicializando tambem a logica cujo clock ainda esta parado.
O reset_monitor amostra 1 ps apos a subida para observar os efeitos do NBA.

O DUT RTL completo permanece inalterado em frontend/rtl. SPI/AES/PLL/RAM sao
partes do DUT, nao VIPs futuros. Os sinais externos SPI/MEMORY ficam ligados
a constantes ociosas no top, sem interfaces UVM ou gerador de mem_clk.
A observacao hierarquica do controle e somente leitura, sem force.

## Testes

- minisoc_smoke_test: reset por 8 ciclos e mais 32 ciclos de observacao.
- minisoc_clock_reset_test: bootstrap e dois resets ociosos adicionais, de 2 e
  12 ciclos. O checker exige tres pulsos observados.

Checagens: periodo 0,5 ns e high/low 0,25 ns (tolerancia 1 ps), largura minima
observada do reset de dois ciclos, liberacao do reset, defaults dos registros
(incluindo NUM_BLOCKS=1 e PLL_DIV_SEL=3), PLL desabilitado, LOCKED=0, sys_clk=0
 e reset interno AES ativo. Ha watchdog global de 10 us e deteccao de parada
do clock apos a primeira medicao. Duracoes de reset sao escolhas do TB.

Nao sao exigidos RAM ou mem_o_data zerados. Nao se verifica AES processando,
PLL habilitado, SPI transacional, ownership ativo ou cobertura completa.
Modelos, scoreboard e testes desses cenarios foram retirados desta versao.

## Waves

```bash
make vcs_run SIM_ARGS="+DUMP_VCD +VCD=stage1.vcd"
make vcs_fsdb_run FSDB_FILE=stage1.fsdb
make verdi_wf FSDB_FILE=stage1.fsdb
make vcs_gui UVM_TESTNAME=minisoc_smoke_test
```

FSDB requer integracao VCS/Verdi do servidor. Flags adicionais podem ser
fornecidas em VCS_EXTRA_FLAGS; VCD nao depende dessa integracao.

## Validacao

Analise estatica com pyslang e Accellera UVM 1.2: zero erros e dois avisos na
propria UVM. Usa timescale 1ns/1ps, UVM_NO_DPI e ignora system tasks de PLI.
Os sete testes Python do verificador de logs passaram na revisao do ambiente. Isso nao substitui
simulacao: VCS/Verdi nao estao disponiveis neste computador. Executar make
stage1 no servidor para confirmar comportamento e coletar evidencias.
