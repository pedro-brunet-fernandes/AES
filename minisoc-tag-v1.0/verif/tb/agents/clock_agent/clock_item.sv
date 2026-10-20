class clock_item extends uvm_sequence_item;
  `uvm_object_utils(clock_item)
  rand int unsigned cycles; constraint c {cycles inside {[1:1000]};}
  function new(string name="clock_item"); super.new(name); endfunction
endclass
