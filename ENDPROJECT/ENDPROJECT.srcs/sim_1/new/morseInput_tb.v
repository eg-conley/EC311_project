`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2024 06:42:13 PM
// Design Name: 
// Module Name: morseInput_tb
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

module morseInput_tb(

    );
    
    reg clk, reset, dot, dash;
    wire [8:0] letterOut;
    
    morseInput mor(clk, reset, dot, dash, letterOut);
    
    always #0.5 clk = ~clk;
    
    initial begin
        dot = 0;
        dash = 0;
        clk = 0;
        reset = 0;
        
        #3 dash = 1;
        #6 dash = 0;
        
        #3 dash = 1;
        #6 dash = 0;
        
        #3 dot = 1;
        #6 dot = 0;
        
        #3 dash = 1;
        #6 dash = 0;
        
        #10;
        
        #3 dash = 1;
        #6 dash = 0;
        
        #3 dot = 1;
        #6 dot = 0;
        
        #1 reset = 1;
        #6 reset = 0;
        
        #3 dot = 1;
        #6 dot = 0;
        
        #30 $finish;
    end
    
endmodule
