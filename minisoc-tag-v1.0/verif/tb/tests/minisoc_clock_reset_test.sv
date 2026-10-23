class minisoc_clock_reset_test extends minisoc_smoke_test;
  `uvm_component_utils(minisoc_clock_reset_test)
  function new(string name,uvm_component parent);super.new(name,parent);endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg.expected_reset_pulses=3;
  endfunction
  task run_phase(uvm_phase phase);
    minisoc_smoke_vseq seq=minisoc_smoke_vseq::type_id::create("seq");
    reset_seq rst=reset_seq::type_id::create("rst_again");
    phase.raise_objection(this);
    seq.start(env.vseqr);
    repeat(16) @(negedge cfg.clk_vif.clk);
    // Dois resets adicionais com o AES ocioso.
    for(int i=0;i<2;i++) begin
      rst.hold_cycles=(i==0)?2:12;
      rst.start(env.vseqr.rst_seqr);
      repeat(24) @(negedge cfg.clk_vif.clk);
    end
    phase.drop_objection(this);
  endtask
endclass
