class clock_sequencer extends uvm_sequencer #(clock_item);
  `uvm_component_utils(clock_sequencer)
  function new(string name, uvm_component parent); super.new(name,parent); endfunction
endclass
