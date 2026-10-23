class clock_item extends uvm_sequence_item;
  `uvm_object_utils(clock_item)
  // Um comando configura a geracao continua.
  realtime period_ns = 0.5;
  realtime high_ns, low_ns; // Medidos pelo monitor.
  function new(string name="clock_item"); super.new(name); endfunction
endclass
