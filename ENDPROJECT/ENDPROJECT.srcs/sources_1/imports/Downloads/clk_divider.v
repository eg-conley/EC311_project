`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Module Name:    clk_divider

//////////////////////////////////////////////////////////////////////////////////
module clk_divider(
input clk_in,
input rst,
output reg divided_clk
    );


reg [49:0] toggle_value = 50'd25999999999 ; //((original/goal)/2) - 1 = 50*10^10 - 1 
reg[32:0] cnt;

always@(posedge clk_in or posedge rst)
    begin
        if (rst==1) begin
            cnt <= 0;
            divided_clk <= 0;
        end
    else begin
        if (cnt==toggle_value) begin
            cnt <= 0;
            divided_clk <= ~divided_clk;
        end
        else begin
            cnt <= cnt +1;
            divided_clk <= divided_clk;
        end
    end
end
 
endmodule
