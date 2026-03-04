`timescale 1ns/1ps

module BaudRateTb;

reg clk;
reg reset;

wire tick;
wire [3:0] count;

BaudRate DUT (
    .clk(clk),
    .reset(reset),
    .tick(tick),
    .count(count)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("Baudrate.vcd");
    $dumpvars(0, BaudRateTb);

    clk = 0;
    reset = 1;

    #10 reset = 0;

    $monitor("time=%0t clk=%b count=%b reset=%b tick=%b",
              $time, clk, count, reset, tick);

    #200 $finish;
end

endmodule
