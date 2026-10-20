class minisoc_aes_e2e_vseq extends uvm_sequence;
  `uvm_object_utils(minisoc_aes_e2e_vseq)
  `uvm_declare_p_sequencer(minisoc_virtual_sequencer)
  function new(string name="minisoc_aes_e2e_vseq");super.new(name);endfunction
  task body();
    `uvm_fatal("TODO_AES_E2E","Implement config->memory->PLL lock->AES->compare before running E2E")
  endtask
endclass
