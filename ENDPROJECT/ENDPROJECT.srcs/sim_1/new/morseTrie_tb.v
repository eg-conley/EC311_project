`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 09:11:14 PM
// Design Name: 
// Module Name: morseTrie_tb
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


module morseTrie_tb();
    reg clk, reset, dot, dash, done;
    wire [7:0] letterOut;
    
    morseTrie mor1(clk, reset, dot, dash, done, letterOut);
    
    always #0.5 clk = ~clk;
    
    initial begin
        dot = 0;
        dash = 0;
        clk = 0;
        reset = 0;
        done = 0;
        // display K
        #3 dash = 1;
        #6 dash = 0;
        
        #3 dot = 1;
        #6 dot = 0;
        
        #3 dash = 1;
        #6 dash = 0;
        
        #3 done = 1;
        #6 done = 0;
        
        // display F
        #3 dot = 1;
        #6 dot = 0;
        
        #3 dot = 1;
        #6 dot = 0;
        
        #3 dash = 1;
        #6 dash = 0;
        
        #3 dot = 1;
        #6 dot = 0;
        
        #3 done = 1;
        #6 done = 0;

        
        #30 $finish;
    end
endmodule
