module cell_control_system_interconnect
  #(parameter IN_MSB = 14,
    parameter OUT_MSB = 14,
    parameter NUM_DECIMAL = 6,
    parameter INTERNAL_PRECISION = 15,
    parameter AXI_UNIT_SIZE = 32)
   (
    input		  clk,
    input		  rst,
    input		  param_en,
    input [1344-1:0] axi_params,
    input [IN_MSB:0]	  data,
    input		  data_en,
    output [OUT_MSB:0] data_out,
    output data_out_en);

   localparam NUM_UNITS = 27; // figure this out later after you've programmed the damn thing
   localparam NUM_ADDR_BITS  = $clog2(NUM_UNITS);
   localparam NUM_INPORTS = 1;

   wire [NUM_UNITS*INTERNAL_PRECISION-1:0] wires;
   wire [NUM_UNITS*AXI_UNIT_SIZE-1:0] params;
   assign params = axi_params[1344-1:NUM_UNITS*AXI_UNIT_SIZE];
   wire [NUM_UNITS-1:0]			   enables;
   reg [NUM_UNITS*AXI_UNIT_SIZE-1:0] demux_addrs;

   task do_reset();
      begin
      demux_addrs <= {32'h1a,
32'h0,
32'h9,
32'h11,
32'h8,
32'h7,
32'h6,
32'h5,
32'h4,
32'h3,
32'h2,
32'h8,
32'h7,
32'h6,
32'h5,
32'h4,
32'h3,
32'h2,
32'h1a,
32'h7,
32'h6,
32'h5,
32'h4,
32'h3,
32'h2,
32'h1a,
32'h19};   
      end
   endtask // do_reset
      
   always @(posedge clk or posedge rst) begin
      if(rst)
	do_reset();
      else begin
	 if(param_en)
	   demux_addrs <= axi_params[NUM_UNITS*AXI_UNIT_SIZE-1:0];
      end
   end
   
   assign data_out = wires[1*INTERNAL_PRECISION+:OUT_MSB];
   assign data_out_en = enables[1];   // unit 0, in port for data
   inport #(
	    .MSB(INTERNAL_PRECISION-1),
	    .IN_MSB(INTERNAL_PRECISION-1)
	    ) Input
     (.clk(clk),
      .rst(rst),
      .in_data(data),
      .in_data_en(data_en),
      .internal_data(wires[0*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
      .internal_data_en(enables[0]));
   // unit 1, out port for data
   wire [NUM_ADDR_BITS-1:0]		    Output_addr;
   assign Output_addr = demux_addrs[0*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   outport
     #(.OUT_MSB(INTERNAL_PRECISION-1),
       .MSB(INTERNAL_PRECISION-1),
       .NUM_BITS_DECIMAL(0)) Output
       (
	.clk(clk),
	.rst(rst),
	.internal_data(wires[Output_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.internal_data_en(enables[Output_addr]),
	.out_data(wires[1*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.out_data_en(enables[1])
	);
   // unit 2, Order1 integrator
   wire [NUM_ADDR_BITS-1:0]		    Order1_addr;
   assign Order1_addr = demux_addrs[1*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   integrator
     #(.MSB(INTERNAL_PRECISION-1)) Order1
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order1_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order1_addr]),
	.param_in(params[1*AXI_UNIT_SIZE+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[2*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[2])
	);
   // unit 3, Order2 integrator
   wire [NUM_ADDR_BITS-1:0]		    Order2_addr;
   assign Order2_addr = demux_addrs[2*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   integrator
     #(.MSB(INTERNAL_PRECISION-1)) Order2
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order2_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order2_addr]),
	.param_in(params[2*AXI_UNIT_SIZE+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[3*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[3])
	);
   // unit 4, Order3 integrator
   wire [NUM_ADDR_BITS-1:0]		    Order3_addr;
   assign Order3_addr = demux_addrs[3*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   integrator
     #(.MSB(INTERNAL_PRECISION-1)) Order3
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order3_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order3_addr]),
	.param_in(params[3*AXI_UNIT_SIZE+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[4*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[4])
	);
   // unit 5, Order4 integrator
   wire [NUM_ADDR_BITS-1:0]		    Order4_addr;
   assign Order4_addr = demux_addrs[4*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   integrator
     #(.MSB(INTERNAL_PRECISION-1)) Order4
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order4_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order4_addr]),
	.param_in(params[4*AXI_UNIT_SIZE+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[5*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[5])
	);
   // unit 6, Order5 integrator
   wire [NUM_ADDR_BITS-1:0]		    Order5_addr;
   assign Order5_addr = demux_addrs[5*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   integrator
     #(.MSB(INTERNAL_PRECISION-1)) Order5
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order5_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order5_addr]),
	.param_in(params[5*AXI_UNIT_SIZE+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[6*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[6])
	);
   // unit 7, Order6 integrator
   wire [NUM_ADDR_BITS-1:0]		    Order6_addr;
   assign Order6_addr = demux_addrs[6*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   integrator
     #(.MSB(INTERNAL_PRECISION-1)) Order6
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order6_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order6_addr]),
	.param_in(params[6*AXI_UNIT_SIZE+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[7*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[7])
	);
   // unit 8, Order7 integrator
   wire [NUM_ADDR_BITS-1:0]		    Order7_addr;
   assign Order7_addr = demux_addrs[7*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   integrator
     #(.MSB(INTERNAL_PRECISION-1)) Order7
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order7_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order7_addr]),
	.param_in(params[7*AXI_UNIT_SIZE+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[8*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[8])
	);
   // Unit 9, Order0_num_gain Constant gain block
   wire [NUM_ADDR_BITS-1:0]		    Order0_num_gain_addr;
   assign Order0_num_gain_addr = demux_addrs[8*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION-1),
       .GAIN_SIZE(25-1),
       .DEFAULT_GAIN(+25'd216),
       .NUM_DECIMAL(NUM_DECIMAL)) Order0_num_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order0_num_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order0_num_gain_addr]),
	.param_in(params[8*AXI_UNIT_SIZE+:25]),
	.param_en(param_en),
	.out(wires[9*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[9])
	);
   // Unit 10, Order1_num_gain Constant gain block
   wire [NUM_ADDR_BITS-1:0]		    Order1_num_gain_addr;
   assign Order1_num_gain_addr = demux_addrs[9*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION-1),
       .GAIN_SIZE(25-1),
       .DEFAULT_GAIN(-25'd221),
       .NUM_DECIMAL(NUM_DECIMAL)) Order1_num_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order1_num_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order1_num_gain_addr]),
	.param_in(params[9*AXI_UNIT_SIZE+:25]),
	.param_en(param_en),
	.out(wires[10*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[10])
	);
   // Unit 11, Order2_num_gain Constant gain block
   wire [NUM_ADDR_BITS-1:0]		    Order2_num_gain_addr;
   assign Order2_num_gain_addr = demux_addrs[10*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION-1),
       .GAIN_SIZE(25-1),
       .DEFAULT_GAIN(-25'd650),
       .NUM_DECIMAL(NUM_DECIMAL)) Order2_num_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order2_num_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order2_num_gain_addr]),
	.param_in(params[10*AXI_UNIT_SIZE+:25]),
	.param_en(param_en),
	.out(wires[11*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[11])
	);
   // Unit 12, Order3_num_gain Constant gain block
   wire [NUM_ADDR_BITS-1:0]		    Order3_num_gain_addr;
   assign Order3_num_gain_addr = demux_addrs[11*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION-1),
       .GAIN_SIZE(25-1),
       .DEFAULT_GAIN(+25'd662),
       .NUM_DECIMAL(NUM_DECIMAL)) Order3_num_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order3_num_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order3_num_gain_addr]),
	.param_in(params[11*AXI_UNIT_SIZE+:25]),
	.param_en(param_en),
	.out(wires[12*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[12])
	);
   // Unit 13, Order4_num_gain Constant gain block
   wire [NUM_ADDR_BITS-1:0]		    Order4_num_gain_addr;
   assign Order4_num_gain_addr = demux_addrs[12*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION-1),
       .GAIN_SIZE(25-1),
       .DEFAULT_GAIN(+25'd649),
       .NUM_DECIMAL(NUM_DECIMAL)) Order4_num_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order4_num_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order4_num_gain_addr]),
	.param_in(params[12*AXI_UNIT_SIZE+:25]),
	.param_en(param_en),
	.out(wires[13*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[13])
	);
   // Unit 14, Order5_num_gain Constant gain block
   wire [NUM_ADDR_BITS-1:0]		    Order5_num_gain_addr;
   assign Order5_num_gain_addr = demux_addrs[13*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION-1),
       .GAIN_SIZE(25-1),
       .DEFAULT_GAIN(-25'd663),
       .NUM_DECIMAL(NUM_DECIMAL)) Order5_num_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order5_num_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order5_num_gain_addr]),
	.param_in(params[13*AXI_UNIT_SIZE+:25]),
	.param_en(param_en),
	.out(wires[14*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[14])
	);
   // Unit 15, Order6_num_gain Constant gain block
   wire [NUM_ADDR_BITS-1:0]		    Order6_num_gain_addr;
   assign Order6_num_gain_addr = demux_addrs[14*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION-1),
       .GAIN_SIZE(25-1),
       .DEFAULT_GAIN(-25'd217),
       .NUM_DECIMAL(NUM_DECIMAL)) Order6_num_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order6_num_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order6_num_gain_addr]),
	.param_in(params[14*AXI_UNIT_SIZE+:25]),
	.param_en(param_en),
	.out(wires[15*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[15])
	);
   // Unit 16, Order7_num_gain Constant gain block
   wire [NUM_ADDR_BITS-1:0]		    Order7_num_gain_addr;
   assign Order7_num_gain_addr = demux_addrs[15*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION-1),
       .GAIN_SIZE(25-1),
       .DEFAULT_GAIN(+25'd220),
       .NUM_DECIMAL(NUM_DECIMAL)) Order7_num_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order7_num_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order7_num_gain_addr]),
	.param_in(params[15*AXI_UNIT_SIZE+:25]),
	.param_en(param_en),
	.out(wires[16*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[16])
	);
   // Unit 17, Order1_dem_gain Constant gain block
   wire [NUM_ADDR_BITS-1:0]		    Order1_dem_gain_addr;
   assign Order1_dem_gain_addr = demux_addrs[16*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION-1),
       .GAIN_SIZE(25-1),
       .DEFAULT_GAIN(+25'd28),
       .NUM_DECIMAL(NUM_DECIMAL)) Order1_dem_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order1_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order1_dem_gain_addr]),
	.param_in(params[16*AXI_UNIT_SIZE+:25]),
	.param_en(param_en),
	.out(wires[17*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[17])
	);
   // Unit 18, Order2_dem_gain Constant gain block
   wire [NUM_ADDR_BITS-1:0]		    Order2_dem_gain_addr;
   assign Order2_dem_gain_addr = demux_addrs[17*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION-1),
       .GAIN_SIZE(25-1),
       .DEFAULT_GAIN(-25'd316),
       .NUM_DECIMAL(NUM_DECIMAL)) Order2_dem_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order2_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order2_dem_gain_addr]),
	.param_in(params[17*AXI_UNIT_SIZE+:25]),
	.param_en(param_en),
	.out(wires[18*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[18])
	);
   // Unit 19, Order3_dem_gain Constant gain block
   wire [NUM_ADDR_BITS-1:0]		    Order3_dem_gain_addr;
   assign Order3_dem_gain_addr = demux_addrs[18*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION-1),
       .GAIN_SIZE(25-1),
       .DEFAULT_GAIN(-25'd39),
       .NUM_DECIMAL(NUM_DECIMAL)) Order3_dem_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order3_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order3_dem_gain_addr]),
	.param_in(params[18*AXI_UNIT_SIZE+:25]),
	.param_en(param_en),
	.out(wires[19*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[19])
	);
   // Unit 20, Order4_dem_gain Constant gain block
   wire [NUM_ADDR_BITS-1:0]		    Order4_dem_gain_addr;
   assign Order4_dem_gain_addr = demux_addrs[19*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION-1),
       .GAIN_SIZE(25-1),
       .DEFAULT_GAIN(+25'd468),
       .NUM_DECIMAL(NUM_DECIMAL)) Order4_dem_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order4_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order4_dem_gain_addr]),
	.param_in(params[19*AXI_UNIT_SIZE+:25]),
	.param_en(param_en),
	.out(wires[20*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[20])
	);
   // Unit 21, Order5_dem_gain Constant gain block
   wire [NUM_ADDR_BITS-1:0]		    Order5_dem_gain_addr;
   assign Order5_dem_gain_addr = demux_addrs[20*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION-1),
       .GAIN_SIZE(25-1),
       .DEFAULT_GAIN(+25'd206),
       .NUM_DECIMAL(NUM_DECIMAL)) Order5_dem_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order5_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order5_dem_gain_addr]),
	.param_in(params[20*AXI_UNIT_SIZE+:25]),
	.param_en(param_en),
	.out(wires[21*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[21])
	);
   // Unit 22, Order6_dem_gain Constant gain block
   wire [NUM_ADDR_BITS-1:0]		    Order6_dem_gain_addr;
   assign Order6_dem_gain_addr = demux_addrs[21*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION-1),
       .GAIN_SIZE(25-1),
       .DEFAULT_GAIN(-25'd708),
       .NUM_DECIMAL(NUM_DECIMAL)) Order6_dem_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order6_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order6_dem_gain_addr]),
	.param_in(params[21*AXI_UNIT_SIZE+:25]),
	.param_en(param_en),
	.out(wires[22*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[22])
	);
   // Unit 23, Order7_dem_gain Constant gain block
   wire [NUM_ADDR_BITS-1:0]		    Order7_dem_gain_addr;
   assign Order7_dem_gain_addr = demux_addrs[22*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION-1),
       .GAIN_SIZE(25-1),
       .DEFAULT_GAIN(+25'd293),
       .NUM_DECIMAL(NUM_DECIMAL)) Order7_dem_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[Order7_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[Order7_dem_gain_addr]),
	.param_in(params[22*AXI_UNIT_SIZE+:25]),
	.param_en(param_en),
	.out(wires[23*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[23])
	);
   // unit 24, Dem_sum summer
   wire [NUM_ADDR_BITS-1:0]		    Dem_sum_addr;
   assign Dem_sum_addr = demux_addrs[23*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   n_adder
     #(.NUM_BITS(INTERNAL_PRECISION), .num_sums(7)) Dem_sum
       (.clk(clk),
	.rst(rst),
	.data_en(enables[Dem_sum_addr+7-1]),
	.data_in(wires[Dem_sum_addr*INTERNAL_PRECISION+:7*INTERNAL_PRECISION]),
	.data_out(wires[24*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[24]));
   // unit 25, Num_sum summer
   wire [NUM_ADDR_BITS-1:0]		    Num_sum_addr;
   assign Num_sum_addr = demux_addrs[24*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   n_adder
     #(.NUM_BITS(INTERNAL_PRECISION), .num_sums(8)) Num_sum
       (.clk(clk),
	.rst(rst),
	.data_en(enables[Num_sum_addr+8-1]),
	.data_in(wires[Num_sum_addr*INTERNAL_PRECISION+:8*INTERNAL_PRECISION]),
	.data_out(wires[25*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[25]));
   // unit 26-26, error subtractor, note this takes up two entries!
   wire [NUM_ADDR_BITS-1:0]		    Error_subber_main_addr;
   assign Error_subber_main_addr = demux_addrs[25*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   wire [NUM_ADDR_BITS-1:0]		    Error_subber_err_addr;
   assign Error_subber_err_addr = demux_addrs[26*AXI_UNIT_SIZE+:NUM_ADDR_BITS];
   error_subber #(.NUM_BITS(INTERNAL_PRECISION)) Error_subber
     (.clk(clk),
      .rst(rst),
      .data_en(enables[Error_subber_main_addr]),
      .data_in(wires[Error_subber_main_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
      .extra_data(wires[Error_subber_err_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
      .data_out(wires[26*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
      .data_en_out(enables[26]));

endmodule