class minisoc_base_test extends uvm_test;
  `uvm_component_utils(minisoc_base_test)
  minisoc_env env;
  virtual clock_if clock_vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual clock_if)::get(this, "", "clock_vif", clock_vif))
      `uvm_fatal("NOVIF", "Test reference clock missing")
    env = minisoc_env::type_id::create("env", this);
  endfunction

  // Apenas dois agentes: o teste inicia as sequencias diretamente.
  task start_clock_and_reset();
    clock_seq clk = clock_seq::type_id::create("clk");
    reset_seq rst = reset_seq::type_id::create("rst");
    clk.start(env.clk_agt.sequencer);
    rst.start(env.rst_agt.sequencer);
  endtask

  function void report_phase(uvm_phase phase);
    uvm_report_server server;
    super.report_phase(phase);
    server=uvm_report_server::get_server();
    if(server.get_severity_count(UVM_ERROR)==0 && server.get_severity_count(UVM_FATAL)==0)
      `uvm_info("STAGE1_PASS",$sformatf("clock=%0d reset_pulses=%0d released=%0d; clock/reset bootstrap only",env.stage1_checker.clock_samples,env.stage1_checker.reset_pulses,env.stage1_checker.released_samples),UVM_NONE)
    else `uvm_info("STAGE1_FAIL","Inspect UVM errors; stage 1 did not pass",UVM_NONE)
  endfunction
endclass
