class spi_driver extends uvm_driver #(spi_item);
  `uvm_component_utils(spi_driver)
  virtual spi_if vif;
  virtual clock_if clk_vif;
  bit [39:0] unused_rx, rx;
  task automatic send_frame(input bit [39:0] tx, output bit [39:0] received);
    received='0;
    vif.spi_cs_n <= 0;
    for (int i=39;i>=0;i--) begin
      vif.spi_sclk <= 0; vif.spi_mosi <= tx[i];
      #20ns; vif.spi_sclk <= 1; received[i] = vif.spi_miso;
      #20ns; vif.spi_sclk <= 0;
    end
    #20ns; vif.spi_cs_n <= 1; #40ns;
  endtask
  function new(string name,uvm_component parent);super.new(name,parent);endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual spi_if)::get(this,"","vif",vif)) `uvm_fatal("NOVIF","spi driver virtual interface absent")
    if(!uvm_config_db#(virtual clock_if)::get(this,"","clock_vif",clk_vif)) `uvm_fatal("NOVIF","reference clock missing")
  endfunction
  task run_phase(uvm_phase phase);
    spi_item req;
    vif.spi_cs_n <= 1; vif.spi_sclk <= 0; vif.spi_mosi <= 0;
    forever begin
      seq_item_port.get_next_item(req);
      send_frame({req.is_read, req.addr, 1'b0, req.data}, unused_rx);
      if (req.is_read) begin
        // Read request + second 40-bit NOP transfer; MISO response in DATA[31:0].
        repeat (4) @(posedge clk_vif.clk);
        send_frame({1'b0, 6'h3f, 1'b0, 32'b0}, rx);
        req.response = rx[31:0];
      end
      seq_item_port.item_done();
    end
  endtask
endclass
