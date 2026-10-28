# MiniSoC AES - primeira etapa simplificada

Escopo: agentes CLOCK/RESET e smoke de inicialização, com checagem automática.
O RTL em frontend/rtl permanece inalterado. SPI e memória ficam ociosos.

## Executar no servidor

Requisitos: Linux, GNU Make, Python 3 e VCS/UVM 1.2 com licença.
Execute em minisoc-tag-v1.0/verif/tb.

Selecione um teste em Makefile.top, deixando apenas uma linha descomentada:

```makefile
include Makefile.common

# UVM_TESTNAME := minisoc_smoke_test
UVM_TESTNAME := minisoc_clock_reset_test
```

Depois execute:

```bash
make test
make wave
make verdi
```

`make test` compila e executa somente o teste selecionado, com seed 1.
O log é salvo em logs/<teste>_<seed>.log.
`make wave` compila e gera minisoc.fsdb usando o mesmo teste selecionado.
`make verdi` abre a FSDB. Feche o Verdi antes de sobrescrever o arquivo.

Para outro nome, use FSDB_FILE=parte1.fsdb em make wave e make verdi.
FSDB requer integração VCS/Verdi; flags adicionais do servidor podem ser
fornecidas em VCS_EXTRA_FLAGS.

Alternativa VCD:

```bash
make wave_vcd
```

Gera minisoc.vcd. Outro nome pode ser definido com VCD_FILE=arquivo.vcd.
O dump inclui a hierarquia do top/DUT: clock, reset, estado do PLL,
reset interno e registradores de configuração.

Outros comandos:

```bash
make vcs_comp
make vcs_run
make test UVM_TESTNAME=minisoc_smoke_test SEED=1
```

`vcs_comp` somente compila; `vcs_run` usa o executável já compilado.
Recompile após alterar fontes SystemVerilog.
Os alvos stage1 e regression não fazem parte desta versão.

## Estrutura e responsabilidades

- top_tb.sv: DUT, interfaces, observação interna, dumps e timeout.
- agents/clock_agent e agents/reset_agent: item, sequencer, driver e monitor.
- env/minisoc_env.sv: cria agentes e conecta monitores ao checker.
- env/minisoc_stage1_checker.sv: centraliza as checagens automáticas.
- sequences/clock_seq.sv e reset_seq.sv: configuram os estímulos.
- tests/: teste base, smoke e teste adicional de resets em idle.
- scripts/check_stage1_log.py: verifica o resultado registrado no log.
- scripts/test_check_stage1_log.py: testa o verificador de logs.

Fluxo: teste → sequências → agentes → DUT → monitores → checker.
O teste inicia as sequências diretamente nos sequencers dos agentes.
Não há objeto de configuração, virtual sequencer, módulo separado de
assertions ou covergroups nesta versão.
O checker recebe transações dos monitores; não lê o DUT diretamente.

## O que é verificado

Clock de referência de 500 ps, alto/baixo de 250 ps (tolerância de 1 ps),
atividade do clock, aplicação/liberação e quantidade de pulsos de reset.
Também são verificados defaults de controle e bootstrap com PLL desabilitado,
sem lock/sys_clk e com AES mantido em reset.

O monitor de reset amostra o DUT 1 ps após a subida da referência,
depois das atualizações do RTL.
Há detecção de parada do clock e timeout global de 10 us.

Smoke: reset inicial de 8 ciclos, seguido de 32 ciclos de observação.
Clock/reset: mesmo início, mais resets em idle de 2 e 12 ciclos.
O checker exige um ou três pulsos, conforme o teste, e pelo menos duas
amostras consecutivas em reset. Não compara a duração exata de cada pulso.
As durações são escolhas dos testes, não requisitos gerais do DUT.

Coverage e assertions ficam planejados para etapas posteriores.
Não se verifica PLL habilitado, configuração SPI, memória ativa ou AES.
Os dois testes são dirigidos: variar seeds não amplia seus cenários.

## Logs, waveforms e limpeza

O verificador de logs exige resumo sem erros/fatais e STAGE1_PASS.
Guardar logs e waveforms correspondentes ao teste e à versão executada.
Para apresentação, mostrar os três resets e medir período e duty cycle.

`make clean` apaga builds, logs e waveforms.
Guarde suas evidências antes de executar a limpeza.
Os arquivos gerados reaparecem ao compilar, simular e abrir o Verdi.