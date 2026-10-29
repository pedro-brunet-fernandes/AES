// Entradas que recebem transações dos monitores de clock e reset.
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

  function new(string name,uvm_component parent);
    super.new(name,parent);
    clock_export=new("clock_export",this);
    reset_export=new("reset_export",this);
  endfunction

  // Recebe do teste a quantidade esperada de pulsos: 1 ou 3.
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    void'(uvm_config_db#(int unsigned)::get(
      this,"","expected_reset_pulses",expected_reset_pulses));
  endfunction

  // Compara tempos em ns com tolerância de 1 ps.
  function bit close_to(realtime actual, expected);
    realtime delta;
    delta=actual-expected;
    return (delta >= -0.001 && delta <= 0.001);
  endfunction

  // Verifica período de 500 ps e tempos alto/baixo de 250 ps.
  function void write_clock(clock_item tr);
    clock_samples++; last_clock_sample=$realtime;
    if (!close_to(tr.period_ns,0.5) || !close_to(tr.high_ns,0.25) || !close_to(tr.low_ns,0.25))
      `uvm_error("CLK_PERIOD",$sformatf("Expected period/high/low 0.5/0.25/0.25 ns, got %0.3f/%0.3f/%0.3f",tr.period_ns,tr.high_ns,tr.low_ns))
  endfunction

  // Conta pulsos e verifica aplicação/liberação do reset.
  function void write_reset(reset_item tr);
    if (tr.rst_n === 1'b0) begin
      if (!in_reset) reset_pulses++;
      in_reset=1; saw_assertion=1; reset_samples++; reset_low_cycles++;
    end
    else if (tr.rst_n === 1'b1) begin
      // Exige duas amostras baixas; não compara as larguras exatas 8/2/12.
      if (in_reset && reset_low_cycles<2)
        `uvm_error("RST_WIDTH","Reset was held for fewer than two reference-clock samples")
      in_reset=0; reset_low_cycles=0; released_samples++;
      if (!saw_assertion) `uvm_error("RST_ORDER","Reset released before an assertion was observed")
    end
    else `uvm_error("RST_UNKNOWN","rst_n is X/Z")

    // Confere defaults e bootstrap: PLL desabilitado e AES em reset.
    if (tr.control_defaults_ok !== 1'b1)
      `uvm_error("RST_CONTROL","SPI/control registers do not match reset defaults")
    if (tr.pll_enable !== 1'b0 || tr.pll_locked !== 1'b0 ||
        tr.sys_clk !== 1'b0 || tr.sys_rst_n !== 1'b0)
      `uvm_error("BOOTSTRAP","PLL must be disabled, with no lock/sys_clk and AES held in reset")
  endfunction

  // Detecta ausência de novas medidas depois que o clock começou.
  task run_phase(uvm_phase phase);
    forever begin
      #2ns;
      if (clock_samples != 0 && ($realtime-last_clock_sample)>1.0)
        `uvm_fatal("CLK_STOPPED","Reference clock stopped during stage 1")
    end
  endtask

  // Confere atividade mínima, quantidade de pulsos e reset liberado ao final.
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    if (clock_samples<20 || reset_samples<2 || released_samples<10 ||
        reset_pulses!=expected_reset_pulses || in_reset)
      `uvm_error("STAGE1_INCOMPLETE",$sformatf("clock=%0d reset=%0d released=%0d pulses=%0d expected=%0d",clock_samples,reset_samples,released_samples,reset_pulses,expected_reset_pulses))
  endfunction
endclass