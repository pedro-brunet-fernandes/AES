package minisoc_env_pkg;
  timeunit 1ns; timeprecision 1ps;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import clock_pkg::*;
  import reset_pkg::*;
  `include "minisoc_env_cfg.sv"
  `include "minisoc_virtual_sequencer.sv"
  `include "minisoc_stage1_checker.sv"
  `include "minisoc_env.sv"
endpackage
