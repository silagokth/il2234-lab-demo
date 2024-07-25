`timescale 1ns / 1ps

module kw4281_driver #(
    parameter int CLOCK_FREQUENCY = 100000000
) (
    input logic rst_n,
    input logic clk,
    input logic [3:0][3:0] input_bcd,
    output logic [3:0] an,
    output logic [6:0] seg
);
  // We want to multiplex the 4 digits at 1kHz so first we need to divide the clock
  logic clk_1000hz;
  clock_divider #(
      .DIVISOR(CLOCK_FREQUENCY / 1000)
  ) clock_divider_0 (
      .rst_n  (rst_n),
      .clk_in (clk),
      .clk_out(clk_1000hz)
  );

  // 0 to 3 counter to generate the digit select signal (AN)
  logic [1:0] counter;
  always_ff @(posedge clk_1000hz or negedge rst_n) begin
    if (!rst_n) begin
      counter <= 0;
    end else if (counter == 3) begin
      counter <= 0;
    end else begin
      counter <= counter + 1;
    end
  end

  // generate AN one-hot signal (active low)
  always_comb begin
    case (counter)
      2'b00:   an = 4'b1110;
      2'b01:   an = 4'b1101;
      2'b10:   an = 4'b1011;
      2'b11:   an = 4'b0111;
      default: an = 4'b1111;
    endcase
  end

  // bcd to 7 segment decoder
  bcd27s bcd27s_0 (
      .bcd(input_bcd[counter]),
      .seg(seg)
  );
endmodule
