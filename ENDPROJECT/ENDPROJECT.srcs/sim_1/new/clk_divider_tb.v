`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


module clk_divider_tb(

    );
    
    reg clk_in, rst;
    wire div_clk;
    
    clk_divider newclock(clk_in, rst, div_clk);
    
    reg D;
    wire Q, notQ;
    
    dff DUT(D, div_clk, Q, notQ);
    
    initial begin
        D = 1;
        rst = 1;
        clk_in = 0;
        
        #11 rst=0;
        
    
        #300 $finish;
    end
    always #10 clk_in = ~clk_in;
endmodule
