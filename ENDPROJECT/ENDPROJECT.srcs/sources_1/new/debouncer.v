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
    
    reg [99:0] counter;
    
    initial counter = 100'b0;
    initial cleanpush = 0;
    
    always @(clk) begin
    
        if(cleanpush) begin
            counter = 100'b0;
        end
        else if (counter == 5)begin
            cleanpush <= 1;
        end
        else begin
            counter = counter + 1;
        end
        
    end
    
endmodule
