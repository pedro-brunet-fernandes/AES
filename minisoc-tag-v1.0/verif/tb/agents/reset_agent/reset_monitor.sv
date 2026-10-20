class reset_monitor extends uvm_monitor;
  `uvm_component_utils(reset_monitor)
  virtual reset_if vif;
  uvm_analysis_port #(reset_item) ap;
  function new(string name,uvm_component parent);super.new(name,parent);ap=new("ap",this);endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual reset_if)::get(this,"","vif",vif)) `uvm_fatal("NOVIF","reset monitor virtual interface absent")
  endfunction
  task run_phase(uvm_phase phase);
    reset_item tr;
    forever begin @(vif.rst_n); tr = reset_item::type_id::create("tr"); tr.hold_cycles=0; ap.write(tr); end
  endtask
endclass
