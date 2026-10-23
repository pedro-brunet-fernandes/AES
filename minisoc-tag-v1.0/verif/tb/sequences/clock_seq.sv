class clock_seq extends uvm_sequence #(clock_item);
  `uvm_object_utils(clock_seq)
  realtime period_ns=0.5;
  function new(string name="clock_seq"); super.new(name); endfunction
  task body();
    clock_item req=clock_item::type_id::create("req");
    start_item(req); req.period_ns=period_ns; finish_item(req);
  endtask
endclass
