class minisoc_smoke_test extends minisoc_base_test;
  `uvm_component_utils(minisoc_smoke_test)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    start_clock_and_reset();
    repeat (32) @(negedge clock_vif.clk);
    phase.drop_objection(this);
  endtask
endclass
