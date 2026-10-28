`timescale 1ns/1ps
module top_tb;
  import uvm_pkg::*;
  import minisoc_test_pkg::*;
  clock_if clk_if_inst();
  reset_if reset_if_inst();

  minisoc_top dut (
    .clk(clk_if_inst.clk),.rst_n(reset_if_inst.rst_n),
    .spi_sclk(1'b0), .spi_cs_n(1'b1), .spi_mosi(1'b0), .spi_miso(),
    .mem_clk(1'b0), .mem_i_data(32'b0), .mem_i_wr_en(1'b0),
    .mem_i_addr(10'b0), .mem_o_data()
  );

  // Observacao interna do DUT.
  assign reset_if_inst.control_defaults_ok =
      ({dut.spi_cfg_start, dut.spi_cfg_decrypt, dut.spi_cfg_mode,
        dut.spi_cfg_num_blocks, dut.spi_cfg_key, dut.spi_cfg_iv,
        dut.spi_cfg_counter, dut.spi_cfg_mem_sel_aes,
        dut.spi_cfg_pll_enable, dut.spi_cfg_pll_div_sel} ===
       {1'b0,1'b0,3'b000,9'd1,128'b0,128'b0,64'b0,1'b0,1'b0,2'b11});
  assign reset_if_inst.pll_locked=dut.pll_locked;
  assign reset_if_inst.pll_enable=dut.spi_cfg_pll_enable;
  assign reset_if_inst.sys_rst_n=dut.sys_rst_n;
  assign reset_if_inst.sys_clk=dut.sys_clk;

  initial begin
    uvm_config_db#(virtual clock_if)::set(null,"uvm_test_top","clock_vif",clk_if_inst);
    uvm_config_db#(virtual clock_if)::set(null,"uvm_test_top.env.clk_agt.*","vif",clk_if_inst);
    uvm_config_db#(virtual clock_if)::set(null,"uvm_test_top.env.rst_agt.*","clock_vif",clk_if_inst);
    uvm_config_db#(virtual reset_if)::set(null,"uvm_test_top.env.rst_agt.*","vif",reset_if_inst);
    run_test();
  end

  initial begin : vcd_dump
    string vcd_name;
    if($test$plusargs("DUMP_VCD")) begin
      if(!$value$plusargs("VCD=%s",vcd_name)) vcd_name="minisoc.vcd";
      $dumpfile(vcd_name); $dumpvars(0,top_tb);
    end
  end

  // FSDB requer integracao VCS/Verdi.
  initial begin : fsdb_dump
    string fsdb_name;
    if ($test$plusargs("DUMP_FSDB")) begin
      if (!$value$plusargs("FSDB=%s", fsdb_name))
        fsdb_name = "minisoc.fsdb";
      $fsdbDumpfile(fsdb_name);
      $fsdbDumpvars(0, top_tb);
    end
  end

  initial begin
    #10us;
    $fatal(1,"Global TB watchdog timeout");
  end

endmodule
