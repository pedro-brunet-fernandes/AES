class reset_item extends uvm_sequence_item;
  `uvm_object_utils(reset_item)
  rand int unsigned hold_cycles; constraint c {hold_cycles inside {[2:20]};}
  function new(string name="reset_item"); super.new(name); endfunction
endclass
