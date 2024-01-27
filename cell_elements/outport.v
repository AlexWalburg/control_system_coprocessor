module outport
  #(parameter OUT_MSB = 23,
    parameter MSB = 31, // internal MSB used
    parameter NUM_BITS_DECIMAL = 8) // number of decimal bits to chop off, you can say less if you want some decimalbits
   (
    input	       clk,
    input	       rst,
    input [OUT_MSB:0]  internal_data,
    input	       internal_data_en,
    output reg [MSB:0] out_data,
    output reg	       out_data_en
    );

   localparam		  MSB_NO_OVERFLOW = OUT_MSB + NUM_BITS_DECIMAL;
   localparam		  NUM_OVERFLOW_BITS = MSB - MSB_NO_OVERFLOW;

   wire			  sign_bit;
   assign sign_bit = internal_data[MSB];
   wire			  overflow;
   generate
      if (NUM_OVERFLOW_BITS > 0) begin
	 wire [NUM_OVERFLOW_BITS-1:0] potential_overflow_bits;
	 assign potential_overflow_bits = internal_data[MSB-1:MSB_NO_OVERFLOW];
	 assign overflow  = |{NUM_OVERFLOW_BITS{sign_bit}}^potential_overflow_bits;
      end
      else begin
	 assign overflow = 0; // cannot overflow as MSB = OUT_MSB
      end
   endgenerate
   
   always @(posedge rst or posedge clk) begin
      if(rst) begin
	 out_data <= 0;
	 out_data_en <= 0;
      end
      else begin
	 if(overflow) // clip to max if overflow, might be worth exporting this bit?
	   out_data <= {sign_bit,{OUT_MSB{~sign_bit}}};
	 else
	   out_data <= {sign_bit,internal_data[NUM_BITS_DECIMAL+:OUT_MSB-1]};
	 out_data_en <= internal_data_en;
      end
   end	
endmodule // inport
