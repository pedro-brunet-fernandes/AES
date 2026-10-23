interface reset_if;
  timeunit 1ns; timeprecision 1ps;
  // Permite ao driver criar uma borda de reset em tempo zero.
  logic rst_n = 1;
  // Sinais de observacao conectados pelo top_tb.
  logic control_defaults_ok, pll_locked, pll_enable, sys_rst_n, sys_clk;
endinterface
