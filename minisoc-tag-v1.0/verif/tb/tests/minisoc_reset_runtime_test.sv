class minisoc_reset_runtime_test extends minisoc_base_test;
  `uvm_component_utils(minisoc_reset_runtime_test)
  function new(string name,uvm_component parent);super.new(name,parent);endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_fatal("NOT_IMPLEMENTED","minisoc_reset_runtime_test requires stimuli and self-checking implementation")
    phase.drop_objection(this);
  endtask
endclass
