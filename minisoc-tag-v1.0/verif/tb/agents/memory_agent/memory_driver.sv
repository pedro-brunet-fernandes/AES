class memory_driver extends uvm_driver #(memory_item);
  `uvm_component_utils(memory_driver)
  virtual memory_if vif;
  function new(string name,uvm_component parent);super.new(name,parent);endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual memory_if)::get(this,"","vif",vif)) `uvm_fatal("NOVIF","memory driver virtual interface absent")
  endfunction
  task run_phase(uvm_phase phase);
    memory_item req;
    vif.mem_i_wr_en <= 0; vif.mem_i_addr <= 0; vif.mem_i_data <= 0;
    forever begin
      seq_item_port.get_next_item(req);
      @(negedge vif.mem_clk);
      vif.mem_i_addr <= req.addr; vif.mem_i_data <= req.data;
      vif.mem_i_wr_en <= req.write;
      @(posedge vif.mem_clk);
      #1ps;
      if (!req.write) req.response=vif.mem_o_data;
      @(negedge vif.mem_clk); vif.mem_i_wr_en <= 0;
      seq_item_port.item_done();
    end
  endtask
endclass
