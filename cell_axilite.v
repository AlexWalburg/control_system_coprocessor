module cell_axilite
  #(parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter DATA_RESET = 0)
   (
    input		    aclk,
    input		    aresetn,
    // read addr channel
    input [ADDR_WIDTH-1:0]  araddr,
    input [3:0]		    arcache, // ignored
    input [2:0]		    arprotect, // ignored
    input		    arvalid,
    output		    arready,
    // read data channel
    output [DATA_WIDTH-1:0] rdata,
    output [1:0]	    rresp,
    output		    rvalid,
    input		    rready,
    // write address channel
    input [ADDR_WIDTH-1:0]  awaddr,
    input [3:0]		    awcache, // ignored
    input [2:0]		    awprot, // ignored
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
    input		    bready,
    // id's for reflection
    input [3:0]		    awid,
    output [3:0]	    wid,
    input [3:0]		    arid,
    input [3:0]		    rid
    output [3:0]	    bid,
    
    );
   // response definitions for bresp,rresp, etc
   localparam		    RESP_OKAY = 0;
   localparam		    RESP_EXOKAY = 1;
   localparam		    RESP_SLVERR = 2;
   localparam		    RESP_DECERR = 3;



   
endmodule // cell_axilite

