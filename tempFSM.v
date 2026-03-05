module FSM(
  input clk,
  input reset,          //All input signals are status signals 
  input tx_start,
  input tick,
  input [3:0] count,

  output reg tx,          //All output signals are control signal
  output reg shift,
  output reg load,
  output reg done
);

reg [1:0] state, next_state;

parameter S0 = 2'b00;  // IDLE
parameter S1 = 2'b01;  // START BIT
parameter S2 = 2'b10;  // DATA
parameter S3 = 2'b11;  // STOP

// State register
always @(posedge clk or posedge reset)
begin
    if(reset)
        state <= S0;
    else
        state <= next_state;
end


// Next state + outputs
always @(*)
begin
    // default values
    tx = 1'b1;
    shift = 1'b0;
    load = 1'b0;
    done = 1'b0;
    next_state = state;

    case(state)

    S0: begin
        if(tx_start) begin
            load = 1'b1;
            next_state = S1;
        end
    end

    S1: begin
       tx = 1'b0; // start bit
      if(tick)
            next_state = S2;
      end

    S2: begin
        if(tick) begin
            shift = 1'b1;
            if(count == 4'd8)
                next_state = S3;
        end
    end

    S3: begin
        tx = 1'b1; // stop bit
        done = 1'b1;
        next_state = S0;
    end

    endcase
end

endmodule
