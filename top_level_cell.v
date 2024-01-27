module top_level_cell
  #(parameter VOL_MSB  = 23)
  (
   // axi signals
   input		   aclk,
   input		   aresetn,
   // read addr channel
   input [ADDR_SIZE-1:0]   araddr,
   input		   arvalid,
   output		   arready,
    // read data channel
   output [DATA_WIDTH-1:0] rdata,
   output [1:0]		   rresp,
   output		   rvalid,
   input		   rready,
   // write address channel
   input [ADDR_SIZE-1:0]   awaddr,
   input		   awvalid,
   output		   awready,
   // write data channel
   input [DATA_WIDTH-1:0]  wdata,
   input [num_strobe-1:0]  wstrb,
   input		   wvalid,
   output		   wready,
   // write response channel
   output [1:0]		   bresp,
   output		   bvalid,
   input		   bready
   // input channels
   input [VOL_MSB:0]	   l_data,
   input		   l_data_en,
   input [VOL_MSB:0]	   r_data,
   input		   r_data_en,
   
   // output channels, we should really seperate these out into seperate
   // control cells but that's probably overengineering

   output [VOL_MSB:0]	   l_data_out,
   output		   l_data_out_en,
   output [VOL_MSB:0]	   r_data_out,
   output		   r_data_out_en,
   );


   localparam		   INTERNAL_PRECISION = 64;
   localparam		   NUM_DECIMAL = 8; // number of values dedicated to holding the decimal

   localparam		   NUM_UNITS = ????; // figure this out at the end
   
   
endmodule // top_level_cell
