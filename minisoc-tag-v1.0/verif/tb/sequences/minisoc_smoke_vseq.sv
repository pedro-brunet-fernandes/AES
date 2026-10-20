class minisoc_smoke_vseq extends uvm_sequence;
  `uvm_object_utils(minisoc_smoke_vseq)
  `uvm_declare_p_sequencer(minisoc_virtual_sequencer)
  function new(string name="minisoc_smoke_vseq");super.new(name);endfunction
  task body();
    reset_seq rst=reset_seq::type_id::create("rst");
    rst.start(p_sequencer.rst_seqr);
    `uvm_info("SMOKE","Initial reset complete",UVM_LOW)
  endtask
endclass
