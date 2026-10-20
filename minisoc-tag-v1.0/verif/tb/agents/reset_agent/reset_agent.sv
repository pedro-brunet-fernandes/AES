class reset_agent extends uvm_agent;
  `uvm_component_utils(reset_agent)
  reset_driver driver;
  reset_sequencer sequencer;
  reset_monitor monitor;
  function new(string name,uvm_component parent);super.new(name,parent);endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor=reset_monitor::type_id::create("monitor",this);
    if(get_is_active()==UVM_ACTIVE) begin
      driver=reset_driver::type_id::create("driver",this);
      sequencer=reset_sequencer::type_id::create("sequencer",this);
    end
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(get_is_active()==UVM_ACTIVE) driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction
endclass
