class minisoc_base_test extends uvm_test;
  `uvm_component_utils(minisoc_base_test)
  minisoc_env env;
  minisoc_env_cfg cfg;
  function new(string name,uvm_component parent);super.new(name,parent);endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg=minisoc_env_cfg::type_id::create("cfg");
    if(!uvm_config_db#(virtual clock_if)::get(this,"","clock_vif",cfg.clk_vif)) `uvm_fatal("VIF","clock")
    if(!uvm_config_db#(virtual reset_if)::get(this,"","reset_vif",cfg.rst_vif)) `uvm_fatal("VIF","reset")
    uvm_config_db#(minisoc_env_cfg)::set(this,"env","cfg",cfg);
    env=minisoc_env::type_id::create("env",this);
  endfunction

  function void report_phase(uvm_phase phase);
    uvm_report_server server;
    super.report_phase(phase);
    server=uvm_report_server::get_server();
    if(server.get_severity_count(UVM_ERROR)==0 && server.get_severity_count(UVM_FATAL)==0)
      `uvm_info("STAGE1_PASS",$sformatf("clock=%0d reset_pulses=%0d released=%0d; clock/reset bootstrap only",env.stage1_checker.clock_samples,env.stage1_checker.reset_pulses,env.stage1_checker.released_samples),UVM_NONE)
    else `uvm_info("STAGE1_FAIL","Inspect UVM errors; stage 1 did not pass",UVM_NONE)
  endfunction
endclass
