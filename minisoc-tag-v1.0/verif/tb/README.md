# MiniSoC UVM — Makefiles no padrao do frontend

Este diretorio usa o mesmo estilo do `frontend/tb/Makefile` original:
um `Makefile` com `include Makefile.top` e arquivos `Makefile.*` para selecionar o perfil.
**Nao foram editados arquivos de `frontend/rtl` nem os testbenches originais de `frontend/tb`.**

## Execucao (VCS com suporte a UVM)

```bash
cd minisoc-tag-v1.0/verif/tb
make vcs_comp
make vcs_run UVM_TESTNAME=minisoc_smoke_test SEED=1
make vcs_gui UVM_TESTNAME=minisoc_smoke_test SEED=1
make clean
```

Troque a linha de `include` no Makefile para outro perfil, como `Makefile.spi`,
`Makefile.mem`, `Makefile.clock_reset` ou `Makefile.aes`. Todos compilam o
**MiniSoC completo** com a infraestrutura UVM, mudando o teste selecionado;
eles nao isolam o RTL como fazem os Makefiles em `frontend/tb`.

`Makefile.common` lista RTL, interfaces, packages e top em ordem.
`UVM_TESTNAME` na linha de comando tem prioridade sobre os defaults.

**Estado:** ambiente UVM inicial, nao regressao funcional fechada. Smoke checa
reset. As classes de SPI/memoria/AES end-to-end sao esqueletos: varias nao
executam ainda checagens completas; refmodel AES, scoreboard e coverage exigem
implementacao. Nao afirmar PASS funcional so por finalizar uma classe vazia.

**Validacao:** arquivos organizados e revisados estaticamente; nao compilados
em VCS nesta entrega. O ambiente local nao possui licenca/VCS disponivel.

## Testbench direcionado fornecido pelo instrutor

```bash
cd minisoc-tag-v1.0/frontend/tb
make vcs_comp
make vcs_run
```

Esse fluxo permanece independente e original.
