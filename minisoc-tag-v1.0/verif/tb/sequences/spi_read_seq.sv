class spi_read_seq extends uvm_sequence #(spi_item);
  `uvm_object_utils(spi_read_seq)
  function new(string name="spi_read_seq");super.new(name);endfunction
  task body();
    spi_item req=spi_item::type_id::create("req");
    start_item(req); req.is_read=1;req.addr=6'h0D;req.data='0; finish_item(req);
  endtask
endclass
