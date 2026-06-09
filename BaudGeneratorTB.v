`timescale 1ns/1ns
  
module baudrategenerator_tb;

   reg clk;
   reg rate;
   reg reset;

   wire baud;
   wire [10:0] count;

   baudrategenerator uut(
      .clk(clk),
      .rate(rate),
      .baud(baud),
      .count(count),
      .reset(reset)
   );

   // 50 Khz clock
   always #10000 clk = ~clk;  //HAS been generated on basis of timescale

   initial
   begin
      clk = 0;
      rate = 1;
      reset = 0;

      $monitor("time = %0t | baud = %b | count = %d",
                $time, baud, count);

      #6000000;

      $finish;
   end

endmodule 
