class minisoc_clock_reset_test extends minisoc_smoke_test;
  `uvm_component_utils(minisoc_clock_reset_test)
  function new(string name,uvm_component parent);super.new(name,parent);endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(int unsigned)::set(this,"env.stage1_checker","expected_reset_pulses",3);
  endfunction
  task run_phase(uvm_phase phase);
    reset_seq rst=reset_seq::type_id::create("rst_again");
    phase.raise_objection(this);
    start_clock_and_reset();
    repeat(16) @(negedge clock_vif.clk);
    // Dois resets adicionais com o AES ocioso.
    for(int i=0;i<2;i++) begin
      rst.hold_cycles=(i==0)?2:12;
      rst.start(env.rst_agt.sequencer);
      repeat(24) @(negedge clock_vif.clk);
    end
    phase.drop_objection(this);
  endtask
endclass
