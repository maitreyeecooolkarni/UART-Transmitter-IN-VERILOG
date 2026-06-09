module paritycheck(
    input  [7:0] data,
    output       paritybit
);

assign paritybit = (^data) ? 1'b1 : 1'b0;

endmodule
