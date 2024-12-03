`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/11/2024 11:43:19 AM
// Design Name:
// Module Name: debouncer
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module debouncer(

    input wire clk,
    input wire button,
    output reg cleanpush

    );
   
    reg [49:0] counter;
   
    initial counter = 50'b0;
    initial cleanpush = 0;
   
    always @(posedge clk) begin
   
        if(button == 0) begin
            counter = 50'b0;
            cleanpush = 0;
        end
        if(cleanpush) begin
            counter = 50'b0;
        end
        // change this to 500 before push to fpga
        else if (counter >= 500)begin
            cleanpush <= 1;
        end
        else begin
            counter = counter + 1;
        end
       
    end
   
endmodule
