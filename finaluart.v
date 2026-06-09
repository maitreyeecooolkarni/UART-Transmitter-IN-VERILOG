`timescale 1ns/1ps

// =====================================================
// UART TOP MODULE
// =====================================================

module finaluart(
    input  [7:0] data1,
    input        clk1,
    input        reset1,
    input        start1,
    input        rate1,
    input        reset2,

    output       out1
);

wire baud_clk1;
wire paritywire;


// FSM Instantiation
FSM F1(
    .data(data1),
    .baud(baud_clk1),
    .reset(reset1),
    .start(start1),
    .out(out1),
    .paritybit(paritywire)
);


// Parity Checker Instantiation
paritycheck P1(
    .data(data1),
    .paritybit(paritywire)
);


// Baud Rate Generator Instantiation
baudrategenerator B1(
    .clk(clk1),
    .rate(rate1),
    .baud(baud_clk1),
    .reset(reset2)
);

endmodule



// =====================================================
// BAUD RATE GENERATOR
// =====================================================

module baudrategenerator(
    input clk,
    input rate,
    input reset,

    output reg baud
);

reg [10:0] count;

parameter B9600  = 1'b0;
parameter B19200 = 1'b1;

always @(posedge clk)
begin

    if(reset)
    begin
        count <= 11'd0;
        baud  <= 1'b0;
    end

    else
    begin

        case(rate)

        B9600:
        begin

            if(count == 11'd52)
            begin
                count <= 11'd0;
                baud  <= 1'b1;
            end

            else
            begin
                count <= count + 1'b1;
                baud  <= 1'b0;
            end

        end


        B19200:
        begin

            if(count == 11'd26)
            begin
                count <= 11'd0;
                baud  <= 1'b1;
            end

            else
            begin
                count <= count + 1'b1;
                baud  <= 1'b0;
            end

        end


        default:
        begin
            count <= 11'd0;
            baud  <= 1'b0;
        end

        endcase

    end

end

endmodule



// =====================================================
// PARITY CHECKER
// =====================================================

module paritycheck(
    input  [7:0] data,
    output       paritybit
);

assign paritybit = (^data) ? 1'b1 : 1'b0;

endmodule



// =====================================================
// UART FSM TRANSMITTER
// =====================================================

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
