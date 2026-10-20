verdiSetActWin -win $_OneSearch
simSetSimulator "-vcssv" -exec \
           "/home/pedro.brunet/proj/minisoc-tag-v1.0/verif/tb/simv" -args \
           "+UVM_TESTNAME=minisoc_smoke_test +ntb_random_seed=1 +DUMP_FSDB +FSDB=minisoc.fsdb"
debImport "-dbdir" \
          "/home/pedro.brunet/proj/minisoc-tag-v1.0/verif/tb/simv.daidir"
debLoadSimResult /home/pedro.brunet/proj/minisoc-tag-v1.0/verif/tb/minisoc.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "614" "161" "900" "644"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcHBSelect "top_tb.assertions_i" -win $_nTrace1
srcHBSelect "top_tb.dut" -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
wvSelectGroup -win $_nWave2 {G1}
verdiSetActWin -win $_nWave2
wvSelectGroup -win $_nWave2 {G1}
wvZoom -win $_nWave2 144.061203 155.586100
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSelectGroup -win $_nWave2 {G1}
wvSetCursor -win $_nWave2 146.404439
verdiDockWidgetSetCurTab -dock windowDock_OneSearch
verdiDockWidgetSetCurTab -dock widgetDock_<Message>
verdiSetActWin -dock widgetDock_<Message>
verdiDockWidgetSetCurTab -dock windowDock_OneSearch
verdiSetActWin -win $_OneSearch
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
verdiSetActWin -win $_nWave2
srcHBSelect "top_tb.clk_if_inst" -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHierTreeSort -win $_nTrace1 -moduleDescending
wvScrollDown -win $_nWave2 0
wvSelectGroup -win $_nWave2 {G1}
verdiSetActWin -win $_nWave2
debExit
