module urbana_top (
    input logic CLK_100MHZ,
    input logic [15:0] SW,
    output logic [15:0] LED
);

  assign LED = SW;

endmodule

