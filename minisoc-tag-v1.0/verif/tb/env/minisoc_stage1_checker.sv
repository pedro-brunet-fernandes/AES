`uvm_analysis_imp_decl(_clock)
`uvm_analysis_imp_decl(_reset)
class minisoc_stage1_checker extends uvm_component;
  `uvm_component_utils(minisoc_stage1_checker)
  uvm_analysis_imp_clock #(clock_item,minisoc_stage1_checker) clock_export;
  uvm_analysis_imp_reset #(reset_item,minisoc_stage1_checker) reset_export;
  int unsigned clock_samples, reset_samples, released_samples, reset_pulses;
  int unsigned reset_low_cycles;
  int unsigned expected_reset_pulses = 1;
  bit saw_assertion, in_reset;
  realtime last_clock_sample;
  // Somente eventos observados, nunca apenas comandos enviados ao driver.
  covergroup stage1_clock_cg with function sample(bit valid_clock);
    option.per_instance=1;
    cp_nominal: coverpoint valid_clock { bins nominal_2ghz={1}; }
  endgroup
  covergroup stage1_reset_cg with function sample(bit initial_reset,
                                                 int unsigned cycles,
                                                 bit recovered);
    option.per_instance=1;
    cp_context: coverpoint initial_reset {
      bins initial_boot={1}; bins idle_reassertion={0};
    }
    cp_width: coverpoint cycles {
      bins short_reset={2}; bins boot_reset={8}; bins long_reset={12};
    }
    cp_recovery: coverpoint recovered { bins defaults_restored={1}; }
  endgroup
  function new(string name,uvm_component parent);
    super.new(name,parent);
    stage1_clock_cg=new(); stage1_reset_cg=new();
    clock_export=new("clock_export",this); reset_export=new("reset_export",this);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    void'(uvm_config_db#(int unsigned)::get(this,"","expected_reset_pulses",expected_reset_pulses));
  endfunction
  function bit close_to(realtime actual, expected);
    realtime delta;
    delta=actual-expected;
    return (delta >= -0.001 && delta <= 0.001);
  endfunction
  function void write_clock(clock_item tr);
    stage1_clock_cg.sample(close_to(tr.period_ns,0.5) &&
                           close_to(tr.high_ns,0.25) && close_to(tr.low_ns,0.25));
    clock_samples++; last_clock_sample=$realtime;
    if (!close_to(tr.period_ns,0.5) || !close_to(tr.high_ns,0.25) || !close_to(tr.low_ns,0.25))
      `uvm_error("CLK_PERIOD",$sformatf("Expected period/high/low 0.5/0.25/0.25 ns, got %0.3f/%0.3f/%0.3f",tr.period_ns,tr.high_ns,tr.low_ns))
  endfunction
  function void write_reset(reset_item tr);
    if (tr.rst_n === 1'b0) begin
      if (!in_reset) reset_pulses++;
      in_reset=1; saw_assertion=1; reset_samples++; reset_low_cycles++;
    end
    else if (tr.rst_n === 1'b1) begin
      if (in_reset) begin
        stage1_reset_cg.sample(reset_pulses==1, reset_low_cycles,
          (tr.control_defaults_ok === 1'b1) && (tr.pll_enable === 1'b0) &&
          (tr.pll_locked === 1'b0) && (tr.sys_clk === 1'b0) &&
          (tr.sys_rst_n === 1'b0));
        // Nesta suite dirigida, cada pulso possui uma largura contratada.
        if ((reset_pulses==1 && reset_low_cycles!=8) ||
            (expected_reset_pulses==3 && reset_pulses==2 && reset_low_cycles!=2) ||
            (expected_reset_pulses==3 && reset_pulses==3 && reset_low_cycles!=12))
          `uvm_error("RST_EXACT_WIDTH","Observed reset width differs from directed test")
      end
      if (in_reset && reset_low_cycles<2)
        `uvm_error("RST_WIDTH","Reset was held for fewer than two reference-clock samples")
      in_reset=0; reset_low_cycles=0; released_samples++;
      if (!saw_assertion) `uvm_error("RST_ORDER","Reset released before an assertion was observed")
    end
    else `uvm_error("RST_UNKNOWN","rst_n is X/Z")
    // Primeira etapa: SPI ocioso e PLL desabilitado.
    if (tr.control_defaults_ok !== 1'b1)
      `uvm_error("RST_CONTROL","SPI/control registers do not match reset defaults")
    if (tr.pll_enable !== 1'b0 || tr.pll_locked !== 1'b0 ||
        tr.sys_clk !== 1'b0 || tr.sys_rst_n !== 1'b0)
      `uvm_error("BOOTSTRAP","PLL must be disabled, with no lock/sys_clk and AES held in reset")
  endfunction
  task run_phase(uvm_phase phase);
    forever begin
      #2ns;
      if (clock_samples != 0 && ($realtime-last_clock_sample)>1.0)
        `uvm_fatal("CLK_STOPPED","Reference clock stopped during stage 1")
    end
  endtask
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    `uvm_info("STAGE1_COVERAGE",$sformatf("clock=%0.2f%% reset=%0.2f%%; stage-1 bins only",
      stage1_clock_cg.get_inst_coverage(),stage1_reset_cg.get_inst_coverage()),UVM_LOW)
    if (expected_reset_pulses==3 &&
        (stage1_clock_cg.get_inst_coverage()<99.99 ||
         stage1_reset_cg.get_inst_coverage()<99.99))
      `uvm_error("STAGE1_COVERAGE_GAP","Directed clock/reset test did not hit all stage-1 bins")
    if (clock_samples<20 || reset_samples<2 || released_samples<10 ||
        reset_pulses!=expected_reset_pulses || in_reset)
      `uvm_error("STAGE1_INCOMPLETE",$sformatf("clock=%0d reset=%0d released=%0d pulses=%0d expected=%0d",clock_samples,reset_samples,released_samples,reset_pulses,expected_reset_pulses))
  endfunction
endclass
