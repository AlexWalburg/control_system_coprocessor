module csc // control systems coprocessor
  #(parameter VOL_MSB  = 14)
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
   // input channel
   input [VOL_MSB:0]	   data,
   input		   data_en,

   output [VOL_MSB:0]	   data_out,
   output		   data_out_en,
   );


   wire [1334-1:0]	   axi_data;
   wire			   param_en;

   cell_axilite #(.DATA_SIZE(1334)) axilite_params
     (
      .aclk(aclk),
      .aresetn(aresetn),
      // read addr channel
      .araddr(araddr),
      .arvalid(arvalid),
      .arready(arready),
      // read data channel
      .rdata(rdata),
      .rresp(rresp),
      .rvalid(rvalid),
      .rready(rready),
      // write address channel
      .awaddr(awaddr),
      .awvalid(awvalid),
      .awready(awready),
      // write data channel
      .wdata(wdata),
      .wstrb(wstrb),
      .wvalid(wvalid),
      .wready(wready),
      // write response channel
      .bresp(bresp),
      .bvalid(bvalid),
      .bready(bready),
      .regs_out(axi_data),
      .param_en(param_en));
   
   cell_control_system_interconnect csi
     (.clk(aclk),
      .rst(~aresetn),
      .param_en(param_en),
      .axi_params(axi_data),
      .data(data),
      .data_en(data_en),
      .data_out(data_out),
      .data_out_en(data_out_en));
endmodule // top_level_cell
