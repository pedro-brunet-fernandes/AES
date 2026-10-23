class reset_monitor extends uvm_monitor;
  `uvm_component_utils(reset_monitor)
  virtual reset_if vif;
  virtual clock_if clk_vif;
  uvm_analysis_port #(reset_item) ap;
  function new(string name,uvm_component parent);
    super.new(name,parent); ap=new("ap",this);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual reset_if)::get(this,"","vif",vif))
      `uvm_fatal("NOVIF","reset monitor virtual interface absent")
    if(!uvm_config_db#(virtual clock_if)::get(this,"","clock_vif",clk_vif))
      `uvm_fatal("NOVIF","reset monitor reference clock absent")
  endfunction
  task run_phase(uvm_phase phase);
    reset_item tr;
    forever begin
      @(posedge clk_vif.clk);
      #1ps; // Amostra apos o NBA do RTL.
      tr=reset_item::type_id::create("tr");
      tr.rst_n=vif.rst_n;
      tr.control_defaults_ok=vif.control_defaults_ok;
      tr.pll_locked=vif.pll_locked; tr.pll_enable=vif.pll_enable;
      tr.sys_rst_n=vif.sys_rst_n; tr.sys_clk=vif.sys_clk;
      ap.write(tr);
    end
  endtask
endclass
