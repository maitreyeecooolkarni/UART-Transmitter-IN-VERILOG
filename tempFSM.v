
module FSM(
    input  [7:0] data,
    input        baud,
    input        reset,
    input        start,
    input        paritybit,

    output reg   out
);


// Data + parity frame
wire [8:0] final_data;


// UART sends LSB first
assign final_data = {paritybit, data};


reg [1:0] state, nxtstate;
reg [3:0] stop_count;


// FSM States
parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;


// =====================================================
// STATE REGISTER
// =====================================================

always @(posedge baud)
begin

    if(reset)
        state <= IDLE;

    else
        state <= nxtstate;

end



// =====================================================
// COUNTER LOGIC
// =====================================================

always @(posedge baud)
begin

    if(reset)
        stop_count <= 4'b0000;

    else if(state == DATA)
        stop_count <= stop_count + 1'b1;

    else
        stop_count <= 4'b0000;

end



// =====================================================
// NEXT STATE + OUTPUT LOGIC
// =====================================================

always @(*)
begin

    nxtstate = state;
    out      = 1'b1;

    case(state)

    IDLE:
    begin

        out = 1'b1;

        if(start)
            nxtstate = START;

        else
            nxtstate = IDLE;

    end


    START:
    begin

        // Start bit
        out = 1'b0;

        nxtstate = DATA;

    end


    DATA:
    begin

        // Data bits + parity bit
        out = final_data[stop_count];

        if(stop_count == 4'b1000)
            nxtstate = STOP;

        else
            nxtstate = DATA;

    end


    STOP:
    begin

        // Stop bit
        out = 1'b1;

        nxtstate = IDLE;

    end


    default:
    begin

        out = 1'b1;

        nxtstate = IDLE;

    end

    endcase

end

endmodule
