class memory_sequencer extends uvm_sequencer #(memory_item);
  `uvm_component_utils(memory_sequencer)
  function new(string name, uvm_component parent); super.new(name,parent); endfunction
endclass
