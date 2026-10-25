# Fluxo publico: compile, run, test, regression, wave, verdi, report, cov, clean.
.DEFAULT_GOAL := test

# Argumentos explicitos na linha de comando podem substituir estes padroes.
COVERAGE := 1
COV_DIR := coverage/stage1.vdb
COV_REPORT := coverage/urg_stage1
FSDB_FILE := parte1_clock_reset.fsdb

# Mantem a estrutura de perfis original.
include Makefile.top

PYTHON ?= python3
RUN_LOG ?= run.log
WAVE_TEST ?= minisoc_clock_reset_test
REG_TESTS ?= minisoc_smoke_test minisoc_clock_reset_test
REG_SEEDS ?= 1 2 3

.PHONY: run test regression wave verdi report cov clean help

# Usa o ultimo binario compilado. Para recompilar antes, use compile/test/wave.
run:
	./$(SIMV) $(COV_RUN_FLAGS) +UVM_TESTNAME=$(UVM_TESTNAME) \
		+ntb_random_seed=$(SEED) $(SIM_ARGS) -l $(RUN_LOG)
	$(PYTHON) scripts/check_stage1_log.py $(RUN_LOG)

# Suite basica da parte 1, com logs separados por teste e seed.
test: compile
	@mkdir -p logs
	$(MAKE) run UVM_TESTNAME=minisoc_smoke_test SEED=$(SEED) RUN_LOG=logs/minisoc_smoke_test_$(SEED).log
	$(MAKE) run UVM_TESTNAME=minisoc_clock_reset_test SEED=$(SEED) RUN_LOG=logs/minisoc_clock_reset_test_$(SEED).log

regression: compile
	@mkdir -p logs
	@set -e; for test in $(REG_TESTS); do \
		for seed in $(REG_SEEDS); do \
			echo "Running $$test seed=$$seed"; \
			./$(SIMV) $(COV_FLAGS) $(if $(filter 1,$(COVERAGE)),-cm_name $${test}_$${seed}) +UVM_TESTNAME=$$test \
				+ntb_random_seed=$$seed $(SIM_ARGS) \
				-l logs/$${test}_$${seed}.log; \
			$(PYTHON) scripts/check_stage1_log.py logs/$${test}_$${seed}.log; \
		done; \
	done

# O teste padrao exercita os tres resets. WAVE_TEST seleciona outro teste.
wave: compile
	$(MAKE) run UVM_TESTNAME=$(WAVE_TEST) RUN_LOG=wave.log SIM_ARGS="$(SIM_ARGS) +DUMP_FSDB +FSDB=$(FSDB_FILE)"

verdi:
	verdi -nologo -ssf $(FSDB_FILE)

report:
	urg -dir $(COV_DIR) -report $(COV_REPORT)

cov:
	verdi -cov -covdir $(COV_DIR)

help:
	@echo 'make compile    - Compilar RTL e UVM; coverage habilitado por padrao'
	@echo 'make run        - Executar o teste selecionado sem recompilar'
	@echo 'make test       - Recompilar e executar os dois testes da parte 1'
	@echo 'make regression - Recompilar e executar dois testes x tres seeds'
	@echo 'make wave       - Recompilar e gerar FSDB do teste clock/reset'
	@echo 'make verdi      - Abrir FSDB no Verdi'
	@echo 'make report     - Gerar relatorio HTML com URG'
	@echo 'make cov        - Abrir coverage no Verdi'
	@echo 'make clean      - Remover logs, binarios e waves; preservar coverage/'
	@echo 'Padroes: coverage/stage1.vdb; coverage/urg_stage1; parte1_clock_reset.fsdb'
	@echo 'Exemplo: make run UVM_TESTNAME=minisoc_clock_reset_test SEED=2'

clean:
	rm -rf csrc csrc_cov simv simv.daidir simv_cov simv_cov.daidir
	rm -rf DVEfiles verdiLog vdCovLog logs
	rm -f *.log *.key *.vpd *.fsdb vc_hdrs.h ucli.key
