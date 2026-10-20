class spi_item extends uvm_sequence_item;
  `uvm_object_utils(spi_item)
  rand bit is_read; rand bit [5:0] addr; rand bit [31:0] data; bit [31:0] response;
  function new(string name="spi_item"); super.new(name); endfunction
endclass
