`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 10:02:33 AM
// Design Name: 
// Module Name: clkIndMorseInput_tb
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


module clkIndMorseInput_tb(
    );
    
    reg clk, reset, dot, dash, done;
    wire [8:0] letterOut;
    
    clkIndMorseInput mor1(clk, reset, dot, dash, done, letterOut);
    
    always #0.5 clk = ~clk;
    
    initial begin
        dot = 0;
        dash = 0;
        clk = 0;
        reset = 0;
        done = 0;
        
        #3 dash = 1;
        #6 dash = 0;
        
        #3 dash = 1;
        #6 dash = 0;
        
        #3 dot = 1;
        #6 dot = 0;
        
        #3 dash = 1;
        #6 dash = 0;
        
        #3 done = 1;
        #6 done = 0;
        
        #3 dash = 1;
        #6 dash = 0;
        
        #3 dot = 1;
        #6 dot = 0;
        
        #1 reset = 1;
        #6 reset = 0;
        
        #3 dot = 1;
        #6 dot = 0;
        
        #3 done = 1;
        #6 done = 0;
        
        #15 done = 1;
        #6 done = 0;
        
        #30 $finish;
    end
endmodule
