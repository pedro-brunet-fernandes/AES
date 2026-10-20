// Framework: independent transaction streams must be aligned with ownership
// and synchronous read latency before making PASS/FAIL comparisons.
class minisoc_scoreboard extends uvm_component;
  `uvm_component_utils(minisoc_scoreboard)
  memory_ref_model memory_model;
  aes_ref_model aes_model;
  function new(string name,uvm_component parent);super.new(name,parent);endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    memory_model=memory_ref_model::type_id::create("memory_model");
    aes_model=aes_ref_model::type_id::create("aes_model");
  endfunction
endclass
