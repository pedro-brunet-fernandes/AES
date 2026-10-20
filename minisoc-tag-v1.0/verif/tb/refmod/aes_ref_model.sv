// Extension point: implement INDEPENDENT AES-128 reference model.
// No dummy encryption is returned: scoreboard must not report AES PASS
// until this implementation has been added and validated with NIST vectors.
class aes_ref_model extends uvm_object;
  `uvm_object_utils(aes_ref_model)
  function new(string name="aes_ref_model");super.new(name);endfunction
  virtual function bit predict(input bit [127:0] key, iv, plaintext,
                                input bit [63:0] counter,
                                input bit [2:0] mode,input bit decrypt,
                                output bit [127:0] expected);
    `uvm_error("AES_REF_NOT_IMPLEMENTED","Implement AES reference model before AES E2E tests")
    expected='x;
    return 0;
  endfunction
endclass
