class memory_item extends uvm_sequence_item;
  `uvm_object_utils(memory_item)
  rand bit write; rand bit [9:0] addr; rand bit [31:0] data; bit [31:0] response;
  function new(string name="memory_item"); super.new(name); endfunction
endclass
