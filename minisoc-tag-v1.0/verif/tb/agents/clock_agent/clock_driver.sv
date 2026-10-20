class clock_driver extends uvm_driver #(clock_item);
  `uvm_component_utils(clock_driver)
  virtual clock_if vif;
  function new(string name, uvm_component parent); super.new(name,parent); endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual clock_if)::get(this,"","vif",vif))
      `uvm_fatal("NOVIF", "Clock virtual interface absent")
  endfunction
  // O clock de 2 GHz e gerado pelo top_tb; agent configurado como passivo.
  task run_phase(uvm_phase phase); endtask
endclass
