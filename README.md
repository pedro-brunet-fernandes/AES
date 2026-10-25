# MiniSoC AES

Projeto de verificacao do MiniSoC AES. A parte 1 implementa um ambiente UVM
para clock, reset e inicializacao do controle, com assertions e coverage.
O frontend original foi preservado.

## Estrutura

- `minisoc-tag-v1.0/frontend/`: RTL e testbenches originais.
- `minisoc-tag-v1.0/verif/tb/`: ambiente UVM e Makefiles da parte 1.

Os comandos de teste e os caminhos dos logs estao no
[README do ambiente de verificacao](minisoc-tag-v1.0/verif/tb/README.md).

SPI, memoria, PLL habilitado e processamento AES ficam para as proximas etapas
de verificacao do ambiente UVM.
