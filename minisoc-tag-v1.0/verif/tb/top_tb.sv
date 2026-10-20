`timescale 1ns/1ps
module top_tb;
  import uvm_pkg::*;
  import minisoc_test_pkg::*;
  clock_if clk_if_inst();
  reset_if reset_if_inst();
  spi_if spi_if_inst();
  memory_if memory_if_inst();

  minisoc_top dut (
    .clk(clk_if_inst.clk),.rst_n(reset_if_inst.rst_n),
    .spi_sclk(spi_if_inst.spi_sclk),.spi_cs_n(spi_if_inst.spi_cs_n),
    .spi_mosi(spi_if_inst.spi_mosi),.spi_miso(spi_if_inst.spi_miso),
    .mem_clk(memory_if_inst.mem_clk), .mem_i_data(memory_if_inst.mem_i_data),
    .mem_i_wr_en(memory_if_inst.mem_i_wr_en),.mem_i_addr(memory_if_inst.mem_i_addr),
    .mem_o_data(memory_if_inst.mem_o_data)
  );
  top_assertions assertions_i(.clk(clk_if_inst.clk),.rst_n(reset_if_inst.rst_n));

  initial begin
    clk_if_inst.clk = 1'b0;
    reset_if_inst.rst_n = 1'b0;
    spi_if_inst.spi_sclk = 1'b0;
    spi_if_inst.spi_cs_n = 1'b1;
    spi_if_inst.spi_mosi = 1'b0;
    memory_if_inst.mem_clk = 1'b0;
    memory_if_inst.mem_i_wr_en = 1'b0;
    memory_if_inst.mem_i_addr = '0;
    memory_if_inst.mem_i_data = '0;
  end

  // 2 GHz reference: 0.5 ns period.
  always #0.25ns clk_if_inst.clk = ~clk_if_inst.clk;
  // External memory clock: 100 MHz, <=200 MHz.
  always #5ns memory_if_inst.mem_clk = ~memory_if_inst.mem_clk;

  initial begin
    uvm_config_db#(virtual clock_if)::set(null,"uvm_test_top","clock_vif",clk_if_inst);
    uvm_config_db#(virtual reset_if)::set(null,"uvm_test_top","reset_vif",reset_if_inst);
    uvm_config_db#(virtual spi_if)::set(null,"uvm_test_top","spi_vif",spi_if_inst);
    uvm_config_db#(virtual memory_if)::set(null,"uvm_test_top","memory_vif",memory_if_inst);
    run_test();
  end

  // O FSDB so e gravado quando +DUMP_FSDB for passado ao simv.
  // As system tasks FSDB dependem da integracao VCS/Verdi no servidor.
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
    #2ms;
    $fatal(1,"Global TB watchdog timeout");
  end

  initial begin
    string fsdb_name;

   if ($test$plusargs("DUMP_FSDB")) begin
     if (!$value$plusargs("FSDB=%s", fsdb_name))
        fsdb_name = "minisoc.fsdb";

      $fsdbDumpfile(fsdb_name);
      $fsdbDumpvars(0, top_tb);

      $display("[FSDB] Gravando formas de onda em %s", fsdb_name);
    end
end

endmodule
