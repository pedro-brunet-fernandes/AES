class memory_read_seq extends uvm_sequence #(memory_item);
  `uvm_object_utils(memory_read_seq)
  function new(string name="memory_read_seq");super.new(name);endfunction
  task body();
    memory_item req=memory_item::type_id::create("req");
    start_item(req); req.write=0;req.addr=0;req.data=0; finish_item(req);
  endtask
endclass
