class memory_write_seq extends uvm_sequence #(memory_item);
  `uvm_object_utils(memory_write_seq)
  function new(string name="memory_write_seq");super.new(name);endfunction
  task body();
    memory_item req=memory_item::type_id::create("req");
    start_item(req); req.write=1;req.addr=0;req.data=32'h11223344; finish_item(req);
  endtask
endclass
