package minisoc_env_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import clock_pkg::*;
  import reset_pkg::*;
  import spi_pkg::*;
  import memory_pkg::*;
  `include "minisoc_env_cfg.sv"
  `include "minisoc_virtual_sequencer.sv"
  `include "memory_ref_model.sv"
  `include "aes_ref_model.sv"
  `include "minisoc_scoreboard.sv"
  `include "minisoc_coverage.sv"
  `include "minisoc_env.sv"
endpackage
