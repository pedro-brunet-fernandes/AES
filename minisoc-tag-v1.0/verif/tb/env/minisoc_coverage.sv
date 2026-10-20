class minisoc_coverage extends uvm_component;
  `uvm_component_utils(minisoc_coverage)
  // TODO: COV-01 reset contexts; COV-02 SPI configuration;
  // COV-03 memory operations; COV-04 AES modes and block counts.
  function new(string name,uvm_component parent); super.new(name,parent);endfunction
endclass
