module axilite_read_channel
  #(parameter DATA_SIZE = 32*4,
    parameter ADDR_SIZE = 32,
    parameter DATA_WIDTH = 32,
    parameter RESP_OKAY = 0,
    parameter RESP_EXOKAY = 1,
    parameter RESP_SLVERR = 2,
    parameter RESP_DECERR = 3)
   (
    input		    clk,
    input		    rst,
    // read addr channel
    input [ADDR_SIZE-1:0]  araddr,
    input		    arvalid,
    output		    arready,
    // read data channel
    output [DATA_WIDTH-1:0] rdata,
    output [1:0]	    rresp,
    output		    rvalid,
    input		    rready,
    input [DATA_SIZE-1:0]   regs
    );

   wire			    deassert_addr;
   wire [ADDR_SIZE-1:0]	    held_addr;
   wire			    addr_ready;

   axilite_addr_reader #(.ADDR_WIDTH(ADDR_SIZE)) waddr
     (
      .clk(clk),
      .rst(rst),
      .addr(araddr),
      .valid(arvalid),
      .ready(arready),
      .deassert_addr(deassert_addr),
      .held_addr(held_addr),
      .addr_ready(addr_ready)
      );

   axilite_read_data
     #(
       .DATA_SIZE(DATA_SIZE),
       .ADDR_SIZE(ADDR_SIZE),
       .DATA_WIDTH(DATA_WIDTH),
       .RESP_OKAY(RESP_OKAY),
       .RESP_EXOKAY(RESP_EXOKAY),
       .RESP_SLVERR(RESP_SLVERR),
       .RESP_DECERR(RESP_DECERR))
   reader
     (
      .clk(clk),
      .rst(rst),
      .data(regs),
      .addr(held_addr),
      .addr_good(addr_ready),
      .deassert_addr(deassert_addr),
      .rdata(rdata),
      .rresp(rresp),
      .rready(rready),
      .rvalid(rvalid)
      );
endmodule // axilite_read_channel

