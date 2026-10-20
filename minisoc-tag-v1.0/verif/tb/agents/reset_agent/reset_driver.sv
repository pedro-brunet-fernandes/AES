class reset_driver extends uvm_driver #(reset_item);
  `uvm_component_utils(reset_driver)
  virtual reset_if vif;
  virtual clock_if clk_vif;
  function new(string name,uvm_component parent);super.new(name,parent);endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual reset_if)::get(this,"","vif",vif)) `uvm_fatal("NOVIF","reset driver virtual interface absent")
    if(!uvm_config_db#(virtual clock_if)::get(this,"","clock_vif",clk_vif)) `uvm_fatal("NOVIF","reference clock missing")
  endfunction
  task run_phase(uvm_phase phase);
    reset_item req;
    vif.rst_n <= 1'b0;
    forever begin
      seq_item_port.get_next_item(req);
      vif.rst_n <= 1'b0;
      repeat(req.hold_cycles) @(negedge clk_vif.clk);
      vif.rst_n <= 1'b1;
      seq_item_port.item_done();
    end
  endtask
endclass
