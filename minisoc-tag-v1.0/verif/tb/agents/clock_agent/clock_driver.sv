class clock_driver extends uvm_driver #(clock_item);
  `uvm_component_utils(clock_driver)
  virtual clock_if vif;
  realtime period_ns;
  function new(string name, uvm_component parent); super.new(name,parent); endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual clock_if)::get(this,"","vif",vif))
      `uvm_fatal("NOVIF", "Clock virtual interface absent")
  endfunction
  task run_phase(uvm_phase phase);
    vif.clk = 0;
    seq_item_port.get_next_item(req);
    if (req.period_ns < 0.002)
      `uvm_fatal("CLK_CONFIG","Period must be >= 2 ps")
    period_ns = req.period_ns;
    seq_item_port.item_done();
    forever #(period_ns/2.0) vif.clk = ~vif.clk;
  endtask
endclass
