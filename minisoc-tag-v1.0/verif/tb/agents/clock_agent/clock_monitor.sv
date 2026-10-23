class clock_monitor extends uvm_monitor;
  `uvm_component_utils(clock_monitor)
  virtual clock_if vif;
  uvm_analysis_port #(clock_item) ap;
  function new(string name,uvm_component parent);
    super.new(name,parent); ap=new("ap",this);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual clock_if)::get(this,"","vif",vif))
      `uvm_fatal("NOVIF","clock monitor virtual interface absent")
  endfunction
  task run_phase(uvm_phase phase);
    clock_item tr;
    realtime rise_at, fall_at;
    @(posedge vif.clk); rise_at=$realtime;
    forever begin
      @(negedge vif.clk); fall_at=$realtime;
      @(posedge vif.clk);
      tr=clock_item::type_id::create("tr");
      tr.period_ns=$realtime-rise_at;
      tr.high_ns=fall_at-rise_at;
      tr.low_ns=$realtime-fall_at;
      ap.write(tr);
      rise_at=$realtime;
    end
  endtask
endclass
