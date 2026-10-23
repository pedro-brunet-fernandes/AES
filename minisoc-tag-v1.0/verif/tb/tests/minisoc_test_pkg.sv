package minisoc_test_pkg;
  timeunit 1ns; timeprecision 1ps;
  import uvm_pkg::*;
  import clock_pkg::*;
  import reset_pkg::*;
  import minisoc_env_pkg::*;
  `include "uvm_macros.svh"
  `include "reset_seq.sv"
  `include "clock_seq.sv"
  `include "minisoc_smoke_vseq.sv"
  `include "minisoc_base_test.sv"
  `include "minisoc_smoke_test.sv"
  `include "minisoc_clock_reset_test.sv"
endpackage
