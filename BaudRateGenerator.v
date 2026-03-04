//Baud Rate Generator 
// A basic generator where every 10 clk cycles a tick is generated.

//UART transmitter

//UART baud rate generation

module BaudRate(
  input clk,
  input reset,
  output reg [3:0] count,
  output reg tick
);

  always @(posedge clk) begin           //Counter + Tick
    if(reset) begin
       count <= 4'b0000;
       tick  <= 0;
    end

    else if(count == 4'b1001) begin
       count <= 4'b0000;
       tick  <= 1;
    end

    else begin
       count <= count + 1;
       tick  <= 0;
    end
end
  
endmodule
      
      
      

