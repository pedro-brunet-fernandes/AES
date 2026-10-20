class minisoc_smoke_test extends minisoc_base_test;
  `uvm_component_utils(minisoc_smoke_test)
  function new(string name,uvm_component parent);super.new(name,parent);endfunction
  task run_phase(uvm_phase phase);
    minisoc_smoke_vseq seq=minisoc_smoke_vseq::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(env.vseqr);
    repeat (20) @(posedge cfg.clk_vif.clk);
    if(cfg.rst_vif.rst_n !== 1'b1) `uvm_error("SMOKE","Global reset failed to release")
    else `uvm_info("SMOKE","Basic reset smoke check passed",UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass
