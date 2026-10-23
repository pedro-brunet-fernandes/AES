class minisoc_env extends uvm_env;
  `uvm_component_utils(minisoc_env)
  minisoc_env_cfg cfg;
  clock_agent clk_agt;
  reset_agent rst_agt;
  minisoc_virtual_sequencer vseqr;
  minisoc_stage1_checker stage1_checker;
  function new(string name,uvm_component parent);super.new(name,parent);endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(minisoc_env_cfg)::get(this,"","cfg",cfg)) `uvm_fatal("NOCFG","env cfg missing")
    uvm_config_db#(virtual clock_if)::set(this,"clk_agt.*","vif",cfg.clk_vif);
    uvm_config_db#(virtual reset_if)::set(this,"rst_agt.*","vif",cfg.rst_vif);
    uvm_config_db#(virtual clock_if)::set(this,"rst_agt.*","clock_vif",cfg.clk_vif);
    clk_agt=clock_agent::type_id::create("clk_agt",this);
    rst_agt=reset_agent::type_id::create("rst_agt",this);
    clk_agt.is_active=UVM_ACTIVE;
    rst_agt.is_active=UVM_ACTIVE;
    uvm_config_db#(int unsigned)::set(this,"stage1_checker","expected_reset_pulses",cfg.expected_reset_pulses);
    stage1_checker=minisoc_stage1_checker::type_id::create("stage1_checker",this);
    vseqr=minisoc_virtual_sequencer::type_id::create("vseqr",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vseqr.clk_seqr=clk_agt.sequencer;
    clk_agt.monitor.ap.connect(stage1_checker.clock_export);
    rst_agt.monitor.ap.connect(stage1_checker.reset_export);
    vseqr.rst_seqr=rst_agt.sequencer;
  endfunction
endclass
