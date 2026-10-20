class clock_seq extends uvm_sequence #(clock_item);
  `uvm_object_utils(clock_seq)
  function new(string name="clock_seq");super.new(name);endfunction
  task body();
    clock_item req=clock_item::type_id::create("req");
    start_item(req); req.cycles=10; finish_item(req);
  endtask
endclass
