package clock_pkg;
  timeunit 1ns; timeprecision 1ps;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "clock_item.sv"
  `include "clock_sequencer.sv"
  `include "clock_driver.sv"
  `include "clock_monitor.sv"
  `include "clock_agent.sv"
endpackage
