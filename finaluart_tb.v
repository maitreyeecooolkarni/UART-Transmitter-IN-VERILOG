`timescale 1ns/1ps

module finaluart_tb;

    reg  [7:0] data1;
    reg        clk1;
    reg        reset1;
    reg        start1;
    reg        rate1;
    reg        reset2;

    wire       out1;


    // ==========================================
    // DUT INSTANTIATION
    // ==========================================

    finaluart uut(
        .data1(data1),
        .clk1(clk1),
        .reset1(reset1),
        .start1(start1),
        .rate1(rate1),
        .reset2(reset2),
        .out1(out1)
    );


    // ==========================================
    // SYSTEM CLOCK GENERATION
    // ==========================================

    always #50 clk1 = ~clk1;


    // ==========================================
    // TEST STIMULUS
    // ==========================================

    initial
    begin

        // Initialize signals
        clk1   = 1'b0;
        reset1 = 1'b1;
        reset2 = 1'b1;
        start1 = 1'b0;

        // 0 = 9600 baud
        // 1 = 19200 baud
        rate1  = 1'b0;

        data1  = 8'b10101010;


        // Apply reset
        #100;

        reset1 = 1'b0;
        reset2 = 1'b0;


        // Start transmission
        #100;

        start1 = 1'b1;
       
       #900000;


        $finish;

    end


    // ==========================================
    // MONITOR
    // ==========================================

    initial
    begin

        $monitor(
        "Time=%0t | start=%b | data=%b | out=%b",
        $time,
        start1,
        data1,
        out1
        );

    end

endmodule
