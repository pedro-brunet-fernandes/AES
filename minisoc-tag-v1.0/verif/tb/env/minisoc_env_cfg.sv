class minisoc_env_cfg extends uvm_object;
  `uvm_object_utils(minisoc_env_cfg)
  virtual clock_if clk_vif;
  virtual reset_if rst_vif;
  virtual spi_if spi_vif;
  virtual memory_if mem_vif;
  function new(string name="minisoc_env_cfg"); super.new(name); endfunction
endclass
