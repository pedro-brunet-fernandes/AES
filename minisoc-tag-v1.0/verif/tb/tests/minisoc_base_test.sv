class minisoc_base_test extends uvm_test;
  `uvm_component_utils(minisoc_base_test)
  minisoc_env env;
  minisoc_env_cfg cfg;
  function new(string name,uvm_component parent);super.new(name,parent);endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg=minisoc_env_cfg::type_id::create("cfg");
    if(!uvm_config_db#(virtual clock_if)::get(this,"","clock_vif",cfg.clk_vif)) `uvm_fatal("VIF","clock")
    if(!uvm_config_db#(virtual reset_if)::get(this,"","reset_vif",cfg.rst_vif)) `uvm_fatal("VIF","reset")
    if(!uvm_config_db#(virtual spi_if)::get(this,"","spi_vif",cfg.spi_vif)) `uvm_fatal("VIF","spi")
    if(!uvm_config_db#(virtual memory_if)::get(this,"","memory_vif",cfg.mem_vif)) `uvm_fatal("VIF","memory")
    uvm_config_db#(minisoc_env_cfg)::set(this,"env","cfg",cfg);
    env=minisoc_env::type_id::create("env",this);
  endfunction
endclass
