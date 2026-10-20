interface memory_if; timeunit 1ns; timeprecision 1ps; logic mem_clk = 0; logic [31:0] mem_i_data = 0; logic mem_i_wr_en = 0; logic [9:0] mem_i_addr = 0; logic [31:0] mem_o_data; endinterface
