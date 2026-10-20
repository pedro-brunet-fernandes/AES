class minisoc_env extends uvm_env;
  `uvm_component_utils(minisoc_env)
  minisoc_env_cfg cfg;
  clock_agent clk_agt;
  reset_agent rst_agt;
  spi_agent spi_agt;
  memory_agent mem_agt;
  minisoc_virtual_sequencer vseqr;
  minisoc_scoreboard scoreboard;
  minisoc_coverage coverage;
  function new(string name,uvm_component parent);super.new(name,parent);endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(minisoc_env_cfg)::get(this,"","cfg",cfg)) `uvm_fatal("NOCFG","env cfg missing")
    uvm_config_db#(virtual clock_if)::set(this,"clk_agt.*","vif",cfg.clk_vif);
    uvm_config_db#(virtual reset_if)::set(this,"rst_agt.*","vif",cfg.rst_vif);
    uvm_config_db#(virtual spi_if)::set(this,"spi_agt.*","vif",cfg.spi_vif);
    uvm_config_db#(virtual memory_if)::set(this,"mem_agt.*","vif",cfg.mem_vif);
    uvm_config_db#(virtual clock_if)::set(this,"rst_agt.driver","clock_vif",cfg.clk_vif);
    uvm_config_db#(virtual clock_if)::set(this,"spi_agt.driver","clock_vif",cfg.clk_vif);
    clk_agt=clock_agent::type_id::create("clk_agt",this);
    rst_agt=reset_agent::type_id::create("rst_agt",this);
    spi_agt=spi_agent::type_id::create("spi_agt",this);
    mem_agt=memory_agent::type_id::create("mem_agt",this);
    clk_agt.is_active=UVM_PASSIVE;
    vseqr=minisoc_virtual_sequencer::type_id::create("vseqr",this);
    scoreboard=minisoc_scoreboard::type_id::create("scoreboard",this);
    coverage=minisoc_coverage::type_id::create("coverage",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vseqr.rst_seqr=rst_agt.sequencer;
    vseqr.spi_seqr=spi_agt.sequencer;
    vseqr.mem_seqr=mem_agt.sequencer;
    // TODO: connect monitor analysis ports via FIFOs/subscribers;
    // extend scoreboard to compare expected vs actual independently.
  endfunction
endclass
