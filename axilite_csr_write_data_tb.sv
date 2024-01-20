module axi_csr_write_data_tb();
   reg clk = 0;
   reg rst;

   reg [31:0] waddr;
   reg [31:0] wdata;
   reg [3:0]  wstrb;
   reg	      wvalid;
   wire	      wready;
   wire	      deassert_addr;
   
   always #1 clk <= ~clk;

   task write_data(input [31:0] addr, input [31:0] data, input [3:0] strobe);
      waddr <= addr;
      wdata <= data;
      wstrb <= strobe;
      wvalid <= 1;
      while(~wready) #1;
      wvalid <= 0;
      #2;
   endtask // write_data

   initial begin
      $dumpfile("write_test.vcd");
      $dumpvars(0,csr_write);
   end
   
   initial begin
      rst <= 1;
      #2;
      rst <= 0;
      write_data(0,32'h11223344,4'b1111);
      write_data(4,32'h55667788,4'b1011);
      $finish();
   end

   axilite_csr_write_data csr_write
     (
      .clk(clk),
      .rst(rst),
      .addr(waddr),
      .wdata(wdata),
      .addr_good(1'b1),
      .wvalid(wvalid),
      .wstrobe(wstrb),
      .deassert_addr(deassert_addr),
      .wready(wready)
      );
   
   
endmodule; // axi_csr_write_data_tb
