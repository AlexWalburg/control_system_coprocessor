module cell_axilite
  #(parameter DATA_SIZE = 32*4,
    parameter ADDR_SIZE = 32,
    parameter DATA_WIDTH = 32,
    parameter RESP_OKAY = 0,
    parameter RESP_EXOKAY = 1,
    parameter RESP_SLVERR = 2,
    parameter RESP_DECERR = 3)
   (
    input		    aclk,
    input		    aresetn,
    // read addr channel
    input [ADDR_SIZE-1:0]  araddr,
    input		    arvalid,
    output		    arready,
    // read data channel
    output [DATA_WIDTH-1:0] rdata,
    output [1:0]	    rresp,
    output		    rvalid,
    input		    rready,
    // write address channel
    input [ADDR_SIZE-1:0]  awaddr,
    input		    awvalid,
    output		    awready,
    // write data channel
    input [DATA_WIDTH-1:0]  wdata,
    input [num_strobe-1:0]  wstrb,
    input		    wvalid,
    output		    wready,
    // write response channel
    output [1:0]	    bresp,
    output		    bvalid,
    input		    bready
    );

   localparam		    num_strobe = DATA_WIDTH/8;

   wire [DATA_SIZE-1:0]	    regs;

   wire			    clk = aclk;
   wire			    rst = ~aresetn;

   axilite_write_channel
  #(.DATA_SIZE(DATA_SIZE),
    .ADDR_SIZE(ADDR_SIZE),
    .DATA_WIDTH(DATA_WIDTH),
    .RESP_OKAY(RESP_OKAY),
    .RESP_EXOKAY(RESP_EXOKAY),
    .RESP_SLVERR(RESP_SLVERR),
    .RESP_DECERR(RESP_DECERR)) write_channel
    (
     .clk(clk),
     .rst(rst),
     .awaddr(awaddr),
     .awvalid(awvalid),
     .awready(awready),
     .wdata(wdata),
     .wstrb(wstrb),
     .wvalid(wvalid),
     .wready(wready),
     .bresp(bresp),
     .bvalid(bvalid),
     .bready(bready),
     .regs(regs)
     );

   axilite_read_channel
  #(.DATA_SIZE(DATA_SIZE),
    .ADDR_SIZE(ADDR_SIZE),
    .DATA_WIDTH(DATA_WIDTH),
    .RESP_OKAY(RESP_OKAY),
    .RESP_EXOKAY(RESP_EXOKAY),
    .RESP_SLVERR(RESP_SLVERR),
    .RESP_DECERR(RESP_DECERR)) read_channel
    (
     .clk(clk),
     .rst(rst),
     .araddr(araddr),
     .arvalid(arvalid),
     .arready(arready),
     .rdata(rdata),
     .rresp(rresp),
     .rvalid(rvalid),
     .rready(rready),
     .regs(regs));
endmodule // cell_axilite

