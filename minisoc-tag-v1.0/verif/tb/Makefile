# Perfil com o teste selecionado
.DEFAULT_GOAL := all
include Makefile.top

FSDB_FILE ?= minisoc.fsdb
VCD_FILE  ?= minisoc.vcd
PYTHON    ?= python3
RUN_LOG   ?= logs/$(UVM_TESTNAME)_$(SEED).log

.PHONY: all test wave wave_vcd verdi \
        vcs_run vcs_gui vcs_fsdb_run \
        verdi_wf verdi_sc help clean vcs_clean

# Somente compilar
all: vcs_comp

# Compilar e executar o teste selecionado
test: vcs_comp
	$(MAKE) vcs_run

# Executar usando o binario existente
vcs_run:
	@mkdir -p "$(dir $(RUN_LOG))"
	./simv +UVM_TESTNAME=$(UVM_TESTNAME) \
		+ntb_random_seed=$(SEED) $(SIM_ARGS) -l "$(RUN_LOG)"
	$(PYTHON) scripts/check_stage1_log.py "$(RUN_LOG)"

# Abrir simulacao interativa
vcs_gui:
	./simv -gui +UVM_TESTNAME=$(UVM_TESTNAME) \
		+ntb_random_seed=$(SEED) $(SIM_ARGS)

# Executar e gerar FSDB
vcs_fsdb_run:
	./simv +UVM_TESTNAME=$(UVM_TESTNAME) \
		+ntb_random_seed=$(SEED) \
		+DUMP_FSDB +FSDB=$(FSDB_FILE) \
		$(SIM_ARGS) -l vcs_fsdb_run.log
	$(PYTHON) scripts/check_stage1_log.py vcs_fsdb_run.log

# Compilar e gerar a waveform do teste selecionado
wave: vcs_comp
	$(MAKE) vcs_fsdb_run

# Compilar e gerar VCD
wave_vcd: vcs_comp
	$(MAKE) vcs_run SIM_ARGS="$(SIM_ARGS) +DUMP_VCD +VCD=$(VCD_FILE)"

# Abrir waveform no Verdi
verdi: verdi_wf

verdi_wf:
	verdi -nologo -ssf "$(FSDB_FILE)"

# Abrir base de depuracao
verdi_sc:
	verdi -dbdir simv.daidir

help:
	@echo 'Selecione o teste em Makefile.top'
	@echo 'make                - Compilar RTL + UVM'
	@echo 'make test           - Compilar e executar o teste selecionado'
	@echo 'make wave           - Compilar e gerar FSDB'
	@echo 'make wave_vcd       - Compilar e gerar VCD'
	@echo 'make verdi          - Abrir FSDB no Verdi'
	@echo 'make vcs_run        - Executar o binario existente'
	@echo 'make vcs_gui        - Abrir simulacao interativa'
	@echo 'make verdi_sc       - Abrir base de depuracao'
	@echo 'make clean          - Apagar builds, logs e waveforms'

# Guardar evidencias antes de limpar
clean:
	rm -rf csrc simv simv.daidir simv_cov simv_cov.daidir
	rm -rf DVEfiles verdiLog vdCovLog logs
	rm -f *.log *.key *.vpd *.fsdb *.vcd vc_hdrs.h

vcs_clean: clean