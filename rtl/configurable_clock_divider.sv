`timescale 1ns / 1ps

module configurable_clock_divider #(
    parameter DIVISOR_WIDTH = 16
) (
    input logic rst_n,
    input logic clk_in,
    input logic [DIVISOR_WIDTH-1:0] divisor,
    input logic load,
    output logic clk_out

);

  logic [DIVISOR_WIDTH-1:0] counter, divisor_reg;

  always_ff @(posedge clk_in or negedge rst_n) begin
    if (!rst_n) begin
      counter <= 0;
      clk_out <= 0;
      divisor_reg <= 0;
    end else begin
      if (load) begin
        divisor_reg <= divisor;
        counter <= divisor;
        clk_out <= 0;
      end 
      else if (counter == 0) begin
        counter <= divisor_reg;
        clk_out <= ~clk_out;
      end 
      else begin
        counter <= counter - 1;
      end
    end
  end
endmodule

