//Baud Generator
//With two rates
//Generates a baud tick(kind of baud click)
//50khz clock

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
