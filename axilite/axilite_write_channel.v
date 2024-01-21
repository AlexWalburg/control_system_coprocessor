module axilite_write_channel
  #(parameter DATA_SIZE = 32*4,
    parameter ADDR_SIZE = 32,
    parameter DATA_WIDTH = 32,
    parameter RESP_OKAY = 0,
    parameter RESP_EXOKAY = 1,
    parameter RESP_SLVERR = 2,
    parameter RESP_DECERR = 3)
   (
    input		   clk,
    input		   rst,
    // write address channel
    input [ADDR_SIZE-1:0]  awaddr,
    input		   awvalid,
    output		   awready,
    // write data channel
    input [DATA_WIDTH-1:0] wdata,
    input [num_strobe-1:0] wstrb,
    input		   wvalid,
    output		   wready,
    // write response channel
    output [1:0]	   bresp,
    output		   bvalid,
    input		   bready,
    // internal regs data
    output [DATA_SIZE-1:0] regs
    ); 
   localparam		   num_strobe = DATA_WIDTH/8;

   wire			    addr_ready;
   wire			    deassert_addr;
   wire [ADDR_SIZE-1:0]	    addr_read;
   // internal bresp signals
   wire [1:0]		    resp;
   wire			    resp_valid;

   assign deassert_addr = bvalid && bready; // wait till the bresp handshake to deassert addr reader
   // this assures clean flow through the model

   axilite_addr_reader #(.ADDR_WIDTH(ADDR_SIZE)) waddr
     (
      .clk(clk),
      .rst(rst),
      .addr(awaddr),
      .valid(awvalid),
      .ready(awready),
      .deassert_addr(deassert_addr),
      .held_addr(addr_read),
      .addr_ready(addr_ready)
      );

   axilite_csr_write_data 
     #(
       .DATA_SIZE(DATA_SIZE),
       .ADDR_SIZE(ADDR_SIZE),
       .DATA_WIDTH(DATA_WIDTH),
       .RESP_OKAY(RESP_OKAY),
       .RESP_EXOKAY(RESP_EXOKAY),
       .RESP_SLVERR(RESP_SLVERR),
       .RESP_DECERR(RESP_DECERR)
       )
   write_data_logic
     (
      .clk(clk),
      .rst(rst),
      .wdata(wdata),
      .addr(addr_read),
      .addr_good(addr_ready),
      .wvalid(wvalid),
      .wstrobe(wstrb),
      .regs(regs),
      .wready(wready),
      .resp(resp),
      .resp_valid(resp_valid)
      );

   axilite_bresp bresp_handler
     (
      .clk(clk),
      .rst(rst),
      .resp(resp),
      .resp_valid(resp_valid),
      .bready(bready),
      .bvalid(bvalid),
      .bresp(bresp)
      );
endmodule // axilite_write_channel
    
