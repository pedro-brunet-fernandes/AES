`timescale 1ns/1ps
module top_assertions(input logic clk, rst_n, control_defaults_ok);
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  // Verifica o reset apos o NBA do RTL.
  always @(posedge clk) begin
    #1ps;
    if(rst_n === 1'b0) begin
      a_control_reset: assert(control_defaults_ok === 1'b1)
        else `uvm_error("A_CONTROL_RESET","Control reset defaults violated")
    end
  end
endmodule
