
# Selecione um perfil
# include Makefile.clock_reset
# include Makefile.spi
# include Makefile.mem
# include Makefile.aes
include Makefile.top

FSDB_FILE  ?= minisoc.fsdb
COV_DIR    ?= simv_cov.vdb
COV_REPORT ?= coverage_report

REG_TESTS ?= minisoc_smoke_test minisoc_clock_reset_test
REG_SEEDS ?= 1 2 3

VCS_COV_FLAGS := -cm line+tgl+fsm+branch+cond+assert

.PHONY: all vcs_run vcs_gui vcs_fsdb_run vcs_cov_comp \
        vcs_cov_run cov cov_report verdi_wf verdi_sc \
        regression help clean vcs_clean

all: vcs_comp

vcs_run:
	./simv +UVM_TESTNAME=$(UVM_TESTNAME) \
		+ntb_random_seed=$(SEED) $(SIM_ARGS) -l vcs_run.log

vcs_gui:
	./simv -gui +UVM_TESTNAME=$(UVM_TESTNAME) \
		+ntb_random_seed=$(SEED) $(SIM_ARGS)

vcs_fsdb_run:
	./simv +UVM_TESTNAME=$(UVM_TESTNAME) \
		+ntb_random_seed=$(SEED) \
		+DUMP_FSDB +FSDB=$(FSDB_FILE) \
		$(SIM_ARGS) -l vcs_fsdb_run.log

vcs_cov_comp:
	vcs $(VCS_BASE_FLAGS) -l vcs_cov_comp.log \
		$(VCS_COV_FLAGS) $(TB_INCDIRS) \
		$(RTL_FILES) $(TB_FILES) -top top_tb -o simv_cov

vcs_cov_run:
	./simv_cov +UVM_TESTNAME=$(UVM_TESTNAME) \
		+ntb_random_seed=$(SEED) \
		$(SIM_ARGS) $(VCS_COV_FLAGS) \
		-cm_dir $(COV_DIR) -l vcs_cov_run.log

cov:
	verdi -cov -covdir $(COV_DIR)

cov_report:
	urg -dir $(COV_DIR) -report $(COV_REPORT)

verdi_wf:
	verdi -nologo -ssf $(FSDB_FILE)

verdi_sc:
	verdi -dbdir simv.daidir

regression:
	@mkdir -p logs
	@set -e; for test in $(REG_TESTS); do \
		for seed in $(REG_SEEDS); do \
			echo "Running $$test seed=$$seed"; \
			./simv +UVM_TESTNAME=$$test \
				+ntb_random_seed=$$seed $(SIM_ARGS) \
				-l logs/$${test}_$${seed}.log; \
		done; \
	done

help:
	@echo 'make vcs_comp       - Compilar RTL + UVM'
	@echo 'make vcs_run        - Executar simulacao'
	@echo 'make vcs_gui        - Abrir GUI do VCS'
	@echo 'make vcs_fsdb_run   - Gerar FSDB'
	@echo 'make verdi_wf       - Abrir formas de onda'
	@echo 'make verdi_sc       - Abrir esquematico'
	@echo 'make vcs_cov_comp   - Compilar com cobertura'
	@echo 'make vcs_cov_run    - Executar com cobertura'
	@echo 'make cov            - Abrir cobertura no Verdi'
	@echo 'make cov_report     - Gerar relatorio de cobertura'
	@echo 'make regression     - Executar testes e seeds'
	@echo 'make clean          - Limpar arquivos gerados'

clean:
	rm -rf csrc simv simv.daidir simv_cov simv_cov.daidir
	rm -rf simv.vdb simv_cov.vdb $(COV_DIR) $(COV_REPORT)
	rm -rf DVEfiles verdiLog vdCovLog logs
	rm -f *.log *.key *.vpd *.fsdb vc_hdrs.h ucli.key

vcs_clean: clean
