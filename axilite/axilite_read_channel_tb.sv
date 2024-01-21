module axilite_read_channel_tb();
   reg		    clk = 0;
   reg		    rst;
   // read addr channel
   reg [31:0]	    araddr = 0;
   reg		    arvalid = 0;
   wire		    arready;
   // read data channel
   wire [31:0]	    rdata;
   wire [1:0]	    rresp;
   wire		    rvalid;
   reg		    rready = 0;
   reg [32*4-1:0]   regs = 'h8877665544332211;

   always #1 clk <= ~clk;

   initial begin
      $dumpfile("read_test.vcd");
      $dumpvars(0,readthing);
   end

   initial begin
      rst <= 1;
      #2;
      rst <= 0;
      do_read(0);
      do_read(1);
      $finish();
      
   end

   task do_read(input [31:0] addr);
      araddr <= addr;
      arvalid <= 1;
      rready <= 0;
      #2;
      while(~arready) #1;
      arvalid <= 0;
      while(~rvalid) #1;
      rready <= 1;
      #2;
      rready <= 0;
   endtask // do_read

   axilite_read_channel readthing(.*);
   
endmodule // axilite_read_channel_tb
