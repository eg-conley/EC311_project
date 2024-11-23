`timescale 1ns / 1ps


// CLK DIVIDER FROM 100MHz -> 25 MHz
module clk_divider(
    input clk,            // 100 MHz clock input
    input reset,          // Reset signal
    output reg clk_out    // 25 MHz clock output
);
    reg [1:0] counter;    // 2-bit counter to divide by 4

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 2'b00;
            clk_out <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 2'b11) begin
                clk_out <= ~clk_out;  // Toggle output clock every 4 clock cycles
            end
        end
    end
endmodule

