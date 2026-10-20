class memory_monitor extends uvm_monitor;
  `uvm_component_utils(memory_monitor)
  virtual memory_if vif;
  uvm_analysis_port #(memory_item) ap;
  function new(string name,uvm_component parent);super.new(name,parent);ap=new("ap",this);endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual memory_if)::get(this,"","vif",vif)) `uvm_fatal("NOVIF","memory monitor virtual interface absent")
  endfunction
  task run_phase(uvm_phase phase);
    memory_item tr;
    forever begin
      @(posedge vif.mem_clk); #1ps;
      tr=memory_item::type_id::create("tr");
      tr.addr=vif.mem_i_addr; tr.write=vif.mem_i_wr_en;
      tr.data=vif.mem_i_data; tr.response=vif.mem_o_data;
      ap.write(tr);
    end
  endtask
endclass
