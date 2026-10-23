class minisoc_smoke_test extends minisoc_base_test;
  `uvm_component_utils(minisoc_smoke_test)
  function new(string name,uvm_component parent);super.new(name,parent);endfunction
  task run_phase(uvm_phase phase);
    minisoc_smoke_vseq seq=minisoc_smoke_vseq::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(env.vseqr);
    repeat (32) @(negedge cfg.clk_vif.clk);
    phase.drop_objection(this);
  endtask
endclass
