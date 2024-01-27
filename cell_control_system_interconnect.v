module cell_control_system_interconnect
  #(parameter IN_MSB = 23,
    parameter OUT_MSB = 23,
    parameter NUM_DECIMAL = 8,
    parameter INTERNAL_PRECISION = 64)
   (input [IN_MSB:0] data,
    input data_en);

   localparam NUM_UNITS = 19; // figure this out later after you've programmed the damn thing
   localparam NUM_ADDR_BITS  = $clog2(NUM_UNITS);
   localparam NUM_INPORTS = 1;

   wire [NUM_UNITS*INTERNAL_PRECISION-1:0] wires;
   wire [NUM_UNITS*INTERNAL_PRECISION-1:0] params;
   wire [NUM_UNITS-1:0]			   enables;
   reg [(NUM_UNITS - NUM_INPORTS)*NUM_ADDR_BITS-1:0] demux_addrs;

   // unit 0, in port for data
   inport #(
	    .MSB(INTERNAL_PRECISION),
	    .IN_MSB(IN_MSB),
	    .NUM_BITS_DECIMAL(NUM_DECIMAL)
	    ) data_in
     (.clk(clk),
      .rst(rst),
      .in_data(data),
      .in_data_en(data_en),
      .internal_data(wires[0+:INTERNAL_PRECISION]),
      .internal_data_en(enables[0]));

   // unit 1, out port for data
   wire [NUM_ADDR_BITS-1:0]		    out_addr;
   assign out_addr = demux_addrs[0*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   outport
     #(.OUT_MSB(23),
       .MSB_INTERNAL(INTERNAL_PRECISION),
       .NUM_BITS_DECIMAL(NUM_DECIMAL)) out
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[out_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_in_en(enables[out_addr]),
	.out_data(wires[INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.out_data_en(enables[1])
	);

   // unit 2, first order integrator
   wire [NUM_ADDR_BITS-1:0]		    first_order_addr;
   assign first_order_addr = demux_addrs[1*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   integrator
     #(.MSB(INTERNAL_PRECISION)) first_order
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[first_order_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[first_order_addr]),
	.param_in(params[first_order_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[2*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[2])
	);

   // unit 3, second order integrator
   wire [NUM_ADDR_BITS-1:0]		    second_order_addr;
   assign second_order_addr = demux_addrs[2*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   integrator
     #(.MSB(INTERNAL_PRECISION)) second_order
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[second_order_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[second_order_addr]),
	.param_in(params[second_order_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[3*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[3])
	);
   // unit 4, third order integrator
   wire [NUM_ADDR_BITS-1:0]		    third_order_addr;
   assign third_order_addr = demux_addrs[3*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   integrator
     #(.MSB(INTERNAL_PRECISION)) third_order
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[third_order_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[third_order_addr]),
	.param_in(params[third_order_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[4*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[4])
	);

   // unit 5, fourth order integrator
   wire [NUM_ADDR_BITS-1:0]		    fourth_order_addr;
   assign fourth_order_addr = demux_addrs[4*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   integrator
     #(.MSB(INTERNAL_PRECISION)) fourth_order
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[fourth_order_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[fourth_order_addr]),
	.param_in(params[fourth_order_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[5*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[5])
	);

   // unit 6, fifth order integrator
   wire [NUM_ADDR_BITS-1:0]		    fifth_order_addr;
   assign fifth_order_addr = demux_addrs[5*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   integrator
     #(.MSB(INTERNAL_PRECISION)) fifth_order
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[fifth_order_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[fifth_order_addr]),
	.param_in(params[fifth_order_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[6*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[6])
	);

   // unit 7, sixth order integrator
   wire [NUM_ADDR_BITS-1:0]		    sixth_order_addr;
   assign sixth_order_addr = demux_addrs[6*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   integrator
     #(.MSB(INTERNAL_PRECISION)) sixth_order
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[sixth_order_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[sixth_order_addr]),
	.param_in(params[sixth_order_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[7*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[7])
	);

   // unit 8, seventh order integrator
   wire [NUM_ADDR_BITS-1:0]		    seventh_order_addr;
   assign seventh_order_addr = demux_addrs[7*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   integrator
     #(.MSB(INTERNAL_PRECISION)) seventh_order
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[seventh_order_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[seventh_order_addr]),
	.param_in(params[seventh_order_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[8*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[8])
	);

   // unit 9, numerator second order numerator gain
   wire [NUM_ADDR_BITS-1:0]		    order2_num_gain_addr;
   assign order2_num_gain_addr = demux_addrs[8*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION),.DEFAULT_GAIN('hx)) order2_num_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[order2_num_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[order2_num_gain_addr]),
	.param_in(params[order2_num_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[9*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[9])
	);

   // unit 10, numerator third order numerator gain
   wire [NUM_ADDR_BITS-1:0]		    order3_num_gain_addr;
   assign order3_num_gain_addr = demux_addrs[9*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION),.DEFAULT_GAIN('hx)) order3_num_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[order3_num_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[order3_num_gain_addr]),
	.param_in(params[order3_num_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[10*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[10])
	);

   // unit 11, numerator fourth order numerator gain
   wire [NUM_ADDR_BITS-1:0]		    order4_num_gain_addr;
   assign order4_num_gain_addr = demux_addrs[10*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION),.DEFAULT_GAIN('hx)) order4_num_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[order4_num_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[order4_num_gain_addr]),
	.param_in(params[order4_num_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[11*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[11])
	);

   // unit 12, denominator first order numerator gain
   wire [NUM_ADDR_BITS-1:0]		    order1_dem_gain_addr;
   assign order1_dem_gain_addr = demux_addrs[11*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION),.DEFAULT_GAIN('hx)) order1_dem_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[order1_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[order1_dem_gain_addr]),
	.param_in(params[order1_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[12*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[12])
	);

   // unit 13, denominator second order numerator gain
   wire [NUM_ADDR_BITS-1:0]		    order2_dem_gain_addr;
   assign order2_dem_gain_addr = demux_addrs[12*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION),.DEFAULT_GAIN('hx)) order2_dem_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[order2_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[order2_dem_gain_addr]),
	.param_in(params[order2_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[13*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[13])
	);

   // unit 14, denominator third order numerator gain
   wire [NUM_ADDR_BITS-1:0]		    order3_dem_gain_addr;
   assign order3_dem_gain_addr = demux_addrs[13*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION),.DEFAULT_GAIN('hx)) order3_dem_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[order3_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[order3_dem_gain_addr]),
	.param_in(params[order3_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[14*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[14])
	);" "
   // unit 15, denominator fourth order numerator gain
   wire [NUM_ADDR_BITS-1:0]		    order4_dem_gain_addr;
   assign order4_dem_gain_addr = demux_addrs[14*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION),.DEFAULT_GAIN('hx)) order4_dem_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[order4_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[order4_dem_gain_addr]),
	.param_in(params[order4_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[15*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[15])
	);" "
   // unit 16, denominator fifth order numerator gain
   wire [NUM_ADDR_BITS-1:0]		    order5_dem_gain_addr;
   assign order5_dem_gain_addr = demux_addrs[15*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION),.DEFAULT_GAIN('hx)) order5_dem_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[order5_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[order5_dem_gain_addr]),
	.param_in(params[order5_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[16*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[16])
	);" "
   // unit 17, denominator sixth order numerator gain
   wire [NUM_ADDR_BITS-1:0]		    order6_dem_gain_addr;
   assign order6_dem_gain_addr = demux_addrs[16*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION),.DEFAULT_GAIN('hx)) order6_dem_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[order6_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[order6_dem_gain_addr]),
	.param_in(params[order6_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[17*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[17])
	);" "
   // unit 18, denominator seventh order numerator gain
   wire [NUM_ADDR_BITS-1:0]		    order7_dem_gain_addr;
   assign order7_dem_gain_addr = demux_addrs[17*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   constant_gain
     #(.MSB(INTERNAL_PRECISION),.DEFAULT_GAIN('hx)) order7_dem_gain
       (
	.clk(clk),
	.rst(rst),
	.data_in(wires[order7_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en(enables[order7_dem_gain_addr]),
	.param_in(params[order7_dem_gain_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.param_en(param_en),
	.data_out(wires[18*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[18])
	);

   // unit 19, denominator summer
   wire [NUM_ADDR_BITS-1:0]		    den_sum_addr;
   assign den_sum_addr = demux_addrs[18*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   n_addr
     #(.NUM_BITS(INTERNAL_PRECISION + 1), .num_sums(7)) den_sum
       (.clk(clk),
	.rst(rst),
	.data_en(wires[den_sum_addr]),
	.data_in(wires[den_sum_addr*INTERNAL_PRECISION+:7*INTERNAL_PRECISION]),
	.data_out(wires[19*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[19]));

   // unit 20, numerator summer
   wire [NUM_ADDR_BITS-1:0]		    num_sum_addr;
   assign den_sum_addr = demux_addrs[19*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   n_addr
     #(.NUM_BITS(INTERNAL_PRECISION + 1), .num_sums(3)) den_sum
       (.clk(clk),
	.rst(rst),
	.data_en(enables[num_sum_addr]),
	.data_in(wires[num_sum_addr*INTERNAL_PRECISION+:3*INTERNAL_PRECISION]),
	.data_out(wires[20*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
	.data_en_out(enables[20]));

   // unit 21-22, error subtractor, note this takes up two entries!
   wire [NUM_ADDR_BITS-1:0]		    error_subber_main_addr;
   assign error_subber_main_addr = demux_addrs[20*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   wire [NUM_ADDR_BITS-1:0]		    error_subber_err_addr;
   assign error_subber_err_addr = demux_addrs[21*NUM_ADDR_BITS+:NUM_ADDR_BITS];
   error_subber #(.NUM_BITS(INTERNAL_PRECISION + 1)) err_sub
     (.clk(clk),
      .rst(rst),
      .data_en(enables[error_subber_main_addr]),
      .data_in(wires[error_subber_main_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
      .extra_data(wires[error_subber_err_addr*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
      .data_out(wires[21*INTERNAL_PRECISION+:INTERNAL_PRECISION]),
      .data_en_out(enables[21]));
endmodule; // cell_control_system_interconnect

   
