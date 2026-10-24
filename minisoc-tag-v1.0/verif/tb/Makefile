
# Selecione um perfil
.DEFAULT_GOAL := all
# include Makefile.clock_reset
include Makefile.top

FSDB_FILE  ?= minisoc.fsdb
COV_REPORT ?= coverage/urg_stage1

REG_TESTS ?= minisoc_smoke_test minisoc_clock_reset_test
REG_SEEDS ?= 1 2 3
PYTHON ?= python3
RUN_LOG ?= vcs_run.log


.PHONY: all vcs_run vcs_gui vcs_fsdb_run \
        verdi_wf verdi_sc \
        regression stage1 stage1_cov regression_cov coverage_report verdi_cov help clean vcs_clean

all: vcs_comp

vcs_run:
	./$(SIMV) $(COV_RUN_FLAGS) +UVM_TESTNAME=$(UVM_TESTNAME) \
		+ntb_random_seed=$(SEED) $(SIM_ARGS) -l $(RUN_LOG)
	$(PYTHON) scripts/check_stage1_log.py $(RUN_LOG)

vcs_gui:
	./$(SIMV) $(COV_RUN_FLAGS) -gui +UVM_TESTNAME=$(UVM_TESTNAME) \
		+ntb_random_seed=$(SEED) $(SIM_ARGS)

vcs_fsdb_run:
	./$(SIMV) $(COV_RUN_FLAGS) +UVM_TESTNAME=$(UVM_TESTNAME) \
		+ntb_random_seed=$(SEED) \
		+DUMP_FSDB +FSDB=$(FSDB_FILE) \
		$(SIM_ARGS) -l vcs_fsdb_run.log
	$(PYTHON) scripts/check_stage1_log.py vcs_fsdb_run.log

verdi_wf:
	verdi -nologo -ssf $(FSDB_FILE)

verdi_sc:
	verdi -dbdir $(SIMV).daidir

stage1: vcs_comp
	@mkdir -p logs
	$(MAKE) vcs_run COVERAGE=$(COVERAGE) UVM_TESTNAME=minisoc_smoke_test SEED=$(SEED) RUN_LOG=logs/minisoc_smoke_test_$(SEED).log
	$(MAKE) vcs_run COVERAGE=$(COVERAGE) UVM_TESTNAME=minisoc_clock_reset_test SEED=$(SEED) RUN_LOG=logs/minisoc_clock_reset_test_$(SEED).log

regression: vcs_comp
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

# A coleta e feita pelo VCS; Verdi/URG analisam a base resultante.
stage1_cov:
	$(MAKE) stage1 COVERAGE=1

regression_cov:
	$(MAKE) regression COVERAGE=1

coverage_report:
	urg -dir $(COV_DIR) -report $(COV_REPORT)

verdi_cov:
	verdi -cov -covdir $(COV_DIR)

help:
	@echo 'make stage1_cov     - Recompilar e rodar os dois testes com coverage'
	@echo 'make regression_cov - Regressao com coverage por teste/seed'
	@echo 'make coverage_report - Gerar relatorio URG da base coletada'
	@echo 'make verdi_cov      - Abrir coverage no Verdi'
	@echo 'make stage1         - Compilar e executar os dois testes da primeira etapa'
	@echo 'make vcs_comp       - Compilar RTL + UVM'
	@echo 'make vcs_run        - Executar simulacao'
	@echo 'make vcs_gui        - Abrir GUI do VCS'
	@echo 'make vcs_fsdb_run   - Gerar FSDB'
	@echo 'make verdi_wf       - Abrir formas de onda'
	@echo 'make verdi_sc       - Abrir esquematico'
	@echo 'make regression     - Executar testes e seeds'
	@echo 'make clean          - Limpar arquivos gerados'

clean:
	rm -rf csrc csrc_cov simv simv.daidir simv_cov simv_cov.daidir
	rm -rf DVEfiles verdiLog vdCovLog logs
	rm -f *.log *.key *.vpd *.fsdb vc_hdrs.h ucli.key

vcs_clean: clean
