class minisoc_smoke_vseq extends uvm_sequence;
  `uvm_object_utils(minisoc_smoke_vseq)
  `uvm_declare_p_sequencer(minisoc_virtual_sequencer)
  function new(string name="minisoc_smoke_vseq");super.new(name);endfunction
  task body();
    clock_seq clk=clock_seq::type_id::create("clk");
    reset_seq rst=reset_seq::type_id::create("rst");
    if(p_sequencer.clk_seqr==null || p_sequencer.rst_seqr==null)
      `uvm_fatal("NO_SEQUENCER","Stage 1 needs active CLOCK and RESET agents")
    clk.start(p_sequencer.clk_seqr);
    rst.start(p_sequencer.rst_seqr);
    `uvm_info("SMOKE","Clock started and initial reset applied/released",UVM_LOW)
  endtask
endclass
