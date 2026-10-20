class spi_monitor extends uvm_monitor;
  `uvm_component_utils(spi_monitor)
  virtual spi_if vif;
  uvm_analysis_port #(spi_item) ap;
  function new(string name,uvm_component parent);super.new(name,parent);ap=new("ap",this);endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual spi_if)::get(this,"","vif",vif)) `uvm_fatal("NOVIF","spi monitor virtual interface absent")
  endfunction
  task run_phase(uvm_phase phase);
    spi_item tr;
    bit [39:0] frame;
    forever begin
      @(negedge vif.spi_cs_n);
      tr=spi_item::type_id::create("tr");
      frame='0;
      for(int i=39;i>=0;i--) begin
        @(posedge vif.spi_sclk); frame[i] = vif.spi_mosi;
      end
      @(posedge vif.spi_cs_n);
      tr.is_read=frame[39]; tr.addr=frame[38:33]; tr.data=frame[31:0]; ap.write(tr);
    end
  endtask
endclass
