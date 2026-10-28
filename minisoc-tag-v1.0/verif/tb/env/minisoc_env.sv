class minisoc_env extends uvm_env;
  `uvm_component_utils(minisoc_env)
  clock_agent clk_agt;
  reset_agent rst_agt;
  minisoc_stage1_checker stage1_checker;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    clk_agt = clock_agent::type_id::create("clk_agt", this);
    rst_agt = reset_agent::type_id::create("rst_agt", this);
    stage1_checker = minisoc_stage1_checker::type_id::create("stage1_checker", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    clk_agt.monitor.ap.connect(stage1_checker.clock_export);
    rst_agt.monitor.ap.connect(stage1_checker.reset_export);
  endfunction
endclass
