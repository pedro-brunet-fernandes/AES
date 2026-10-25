`timescale 1ns/1ps
// Parte 1: somente referencia, reset e controle ocioso; nenhuma operacao AES.
module top_assertions(input logic clk, rst_n, control_defaults_ok,
                      pll_enable, pll_locked, sys_clk, sys_rst_n);
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // X->0 na inicializacao de clk tambem pode gerar negedge em tempo zero.
  // Habilita SVA somente apos a primeira subida real da referencia.
  // Nao usar disable iff (!rst_n): queremos verificar inclusive DURANTE reset.
  bit checks_enabled = 1'b0;
  always @(posedge clk) checks_enabled <= 1'b1;

  // Mantem a checagem imediata apos o NBA, inclusive na primeira subida.
  always @(posedge clk) begin
    #1ps;
    if(rst_n === 1'b0) begin
      a_control_reset: assert(control_defaults_ok === 1'b1)
        else `uvm_error("A_CONTROL_RESET","Control reset defaults violated")
    end
  end

  // Na descida, os efeitos da subida anterior ja estao estabilizados.
  // Consequentes no mesmo ciclo evitam tentativas pendentes no fim do teste.
  a_reset_known: assert property (@(negedge clk) disable iff (!checks_enabled) !$isunknown(rst_n))
    else `uvm_error("A_RESET_KNOWN","Reset is X/Z")
  a_control_defaults: assert property (@(negedge clk) disable iff (!checks_enabled)
      control_defaults_ok === 1'b1)
    else `uvm_error("A_CONTROL_DEFAULTS","Idle control defaults violated")
  a_pll_disabled: assert property (@(negedge clk) disable iff (!checks_enabled) pll_enable === 1'b0)
    else `uvm_error("A_PLL_DISABLED","Stage 1 requires PLL disabled")
  a_no_lock_disabled: assert property (@(negedge clk) disable iff (!checks_enabled)
      (pll_enable === 1'b0) |-> (pll_locked === 1'b0))
    else `uvm_error("A_NO_LOCK_DISABLED","Disabled PLL reports lock")
  a_no_sys_clk_unlocked: assert property (@(negedge clk) disable iff (!checks_enabled)
      (pll_locked === 1'b0) |-> (sys_clk === 1'b0))
    else `uvm_error("A_NO_SYS_CLK_UNLOCKED","System clock high without lock")
  a_aes_reset_disabled: assert property (@(negedge clk) disable iff (!checks_enabled)
      (pll_enable === 1'b0) |-> (sys_rst_n === 1'b0))
    else `uvm_error("A_AES_RESET_DISABLED","AES reset released with PLL disabled")

  // Hits explicitos: nao interpretar apenas sucesso vacuo como exercicio.
  c_reset_low: cover property (@(negedge clk) disable iff (!checks_enabled) rst_n === 1'b0);
  c_reset_high: cover property (@(negedge clk) disable iff (!checks_enabled) rst_n === 1'b1);
  c_disabled_bootstrap: cover property (@(negedge clk) disable iff (!checks_enabled)
      (rst_n === 1'b1) && (control_defaults_ok === 1'b1) &&
      (pll_enable === 1'b0) && (pll_locked === 1'b0) &&
      (sys_clk === 1'b0) && (sys_rst_n === 1'b0));
endmodule
