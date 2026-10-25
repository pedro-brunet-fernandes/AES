# MiniSoC AES — Parte 1

Ambiente UVM para verificar clock, reset e inicializacao do controle.
SPI, memoria e processamento AES
ficam fora dos testes desta etapa.

## Preparacao

No servidor, entre na pasta de testes:

```bash
cd /home/pedro.brunet/proj/minisoc-tag-v1.0/verif/tb
```

## Comandos

```bash
make test        # Compila e executa smoke e clock/reset com seed 1
make regression  # Compila e executa os dois testes com seeds 1, 2 e 3
make wave        # Compila e gera waves do teste clock/reset
make verdi       # Abre as waves geradas
make report      # Gera o relatorio de coverage
make cov         # Abre coverage e assertions
```

Execute um comando por vez e pare se houver erro.
Coverage fica habilitado por padrao.

Outros comandos:

```bash
make compile     # Apenas compila
make run         # Executa smoke usando o ultimo binario compilado
make help        # Lista os comandos
make clean       # Apaga logs, binarios e waves; preserva coverage/
```

Para executar um teste especifico:

```bash
make compile
make run UVM_TESTNAME=minisoc_clock_reset_test SEED=2
```

Para gerar waves do smoke:

```bash
make wave WAVE_TEST=minisoc_smoke_test
make verdi
```

Os comandos reutilizam os caminhos definidos no Makefile. Salve os arquivos
que deseja preservar antes de repetir testes ou executar `make clean`.

## Logs

Os caminhos sao relativos a `verif/tb`:

- `vcs_logger.log`: compilacao.
- `logs/<teste>_<seed>.log`: testes e regressao.
- `run.log`: execucao com `make run`.
- `wave.log`: execucao com `make wave`.

`RUN_LOG` permite escolher outro arquivo para `make run`.

