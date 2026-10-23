class reset_seq extends uvm_sequence #(reset_item);
  `uvm_object_utils(reset_seq)
  int unsigned hold_cycles=8;
  function new(string name="reset_seq"); super.new(name); endfunction
  task body();
    reset_item req=reset_item::type_id::create("req");
    start_item(req); req.hold_cycles=hold_cycles; finish_item(req);
  endtask
endclass
