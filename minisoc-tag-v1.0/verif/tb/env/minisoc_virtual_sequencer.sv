class minisoc_virtual_sequencer extends uvm_sequencer;
  `uvm_component_utils(minisoc_virtual_sequencer)
  clock_sequencer clk_seqr;
  reset_sequencer rst_seqr;
  spi_sequencer spi_seqr;
  memory_sequencer mem_seqr;
  function new(string name,uvm_component parent);super.new(name,parent);endfunction
endclass
