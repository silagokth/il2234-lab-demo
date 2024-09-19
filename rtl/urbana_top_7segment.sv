module urbana_top (
    input logic CLK_100MHZ,
    input logic [15:0] SW,
    output logic [15:0] LED,
    output logic [7:0] D1_SEG,
    output logic [3:0] D1_AN
);

    kw4281_driver driver (.rst_n(1'b1), .clk(CLK_100MHZ), 
                          .input_bcd({SW[3:0], SW[7:4], SW[11:8], SW[15:12]}),
                          .an(D1_AN), .seg(D1_SEG[6:0]));
    assign D1_SEG[7] = 1'b1;                         

endmodule

