verdiSetActWin -win $_OneSearch
simSetSimulator "-vcssv" -exec \
           "/home/pedro.brunet/proj/minisoc-tag-v1.0/verif/tb/simv_cov" -args \
           "-cm line+cond+branch+tgl+fsm+assert -cm_dir coverage/stage1.vdb -cm_name minisoc_clock_reset_test_1 +UVM_TESTNAME=minisoc_clock_reset_test +ntb_random_seed=1 +DUMP_FSDB +FSDB=parte1_clock_reset.fsdb"
debImport "-dbdir" \
          "/home/pedro.brunet/proj/minisoc-tag-v1.0/verif/tb/simv_cov.daidir"
debLoadSimResult \
           /home/pedro.brunet/proj/minisoc-tag-v1.0/verif/tb/parte1_clock_reset.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiFindBar -show -win nWave_2
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcHBDrag -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
wvSetPosition -win $_nWave2 {("clk_if_inst(clock_if)" 0)}
wvRenameGroup -win $_nWave2 {G1} {clk_if_inst(clock_if)}
wvAddSignal -win $_nWave2 "/top_tb/clk_if_inst/clk"
wvSetPosition -win $_nWave2 {("clk_if_inst(clock_if)" 0)}
wvSetPosition -win $_nWave2 {("clk_if_inst(clock_if)" 1)}
wvSetPosition -win $_nWave2 {("clk_if_inst(clock_if)" 1)}
wvSetPosition -win $_nWave2 {("G2" 0)}
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("clk_if_inst(clock_if)" 1)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("reset_if_inst(reset_if)" 0)}
wvRenameGroup -win $_nWave2 {G2} {reset_if_inst(reset_if)}
wvAddSignal -win $_nWave2 "/top_tb/reset_if_inst/rst_n" \
           "/top_tb/reset_if_inst/control_defaults_ok" \
           "/top_tb/reset_if_inst/pll_locked" \
           "/top_tb/reset_if_inst/pll_enable" \
           "/top_tb/reset_if_inst/sys_rst_n" "/top_tb/reset_if_inst/sys_clk"
wvSetPosition -win $_nWave2 {("reset_if_inst(reset_if)" 0)}
wvSetPosition -win $_nWave2 {("reset_if_inst(reset_if)" 6)}
wvSetPosition -win $_nWave2 {("reset_if_inst(reset_if)" 6)}
wvSetPosition -win $_nWave2 {("G3" 0)}
debExit
