class clock_monitor extends uvm_monitor;
  `uvm_component_utils(clock_monitor)
  virtual clock_if vif;
  uvm_analysis_port #(clock_item) ap;
  function new(string name,uvm_component parent);super.new(name,parent);ap=new("ap",this);endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual clock_if)::get(this,"","vif",vif)) `uvm_fatal("NOVIF","clock monitor virtual interface absent")
  endfunction
  task run_phase(uvm_phase phase);
    clock_item tr;
    forever begin @(posedge vif.clk); tr = clock_item::type_id::create("tr"); tr.cycles=1; ap.write(tr); end
  endtask
endclass
