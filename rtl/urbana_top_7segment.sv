module urbana_top (
    input logic CLK_100MHZ,
    input logic [15:0] SW,
    output logic [15:0] LED,
    output logic [7:0] D1_SEG,
    output logic [3:0] D1_AN,
    output logic [7:0] D0_SEG,
    output logic [3:0] D0_AN
);
    
    kw4281_driver driver_left (.rst_n(1'b1), .clk(CLK_100MHZ), 
                          .input_bcd({4'b0000, SW[15:12], 4'b0000, SW[11:8]}), .input_dots(4'b1010),
                          .an(D0_AN), .seg(D0_SEG));
    
    kw4281_driver driver_right (.rst_n(1'b1), .clk(CLK_100MHZ), 
                         .input_bcd({SW[7:4], 4'b0000, SW[3:0], 4'b000}), .input_dots(4'b1111),
                          .an(D1_AN), .seg(D1_SEG));
                          
endmodule
