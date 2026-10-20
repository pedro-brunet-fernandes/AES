class memory_ref_model extends uvm_object;
  `uvm_object_utils(memory_ref_model)
  bit valid[1024];
  bit [31:0] words[1024];
  function new(string name="memory_ref_model");super.new(name);endfunction
  function void write_word(bit [9:0] addr, bit [31:0] data);
    words[addr]=data;valid[addr]=1;
  endfunction
  function bit check_word(bit [9:0] addr,bit [31:0] value);
    if (!valid[addr]) return 1; // Uninitialized memory isn't checked
    return words[addr] === value;
  endfunction
endclass
