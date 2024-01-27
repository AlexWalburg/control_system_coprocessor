module inport 
  #(parameter IN_MSB = 23,
    parameter MSB = 31)  // internal MSB used
   (
    input	       clk,
    input	       rst,
    input [IN_MSB:0]   in_data,
    input	       in_data_en,
    output reg [MSB:0] internal_data,
    output reg	       internal_data_en
    );

   localparam	       NUM_REMAINING_BITS = MSB + 1 - (IN_MSB + 1);

   always @(posedge rst or posedge clk) begin
      if(rst) begin
	 internal_data <= 0;
	 internal_data_en <= 0;
      end
      else begin
	 if (NUM_REMAINING_BITS > 0)
	   internal_data <= {{NUM_REMAINING_BITS{in_data[IN_MSB]}},in_data};
	 else
	   internal_data <= in_data;
	 internal_data_en <= in_data_en;
      end
   end	
endmodule // inport
