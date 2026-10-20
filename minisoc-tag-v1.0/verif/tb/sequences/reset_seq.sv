class reset_seq extends uvm_sequence #(reset_item);
  `uvm_object_utils(reset_seq)
  function new(string name="reset_seq");super.new(name);endfunction
  task body();
    reset_item req=reset_item::type_id::create("req");
    start_item(req); req.hold_cycles=8; finish_item(req);
  endtask
endclass
