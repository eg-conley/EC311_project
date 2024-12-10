`timescale 1ns / 1ps
// created directly from https://github.com/FPGADude/Digital-Design/tree/main/FPGA%20Projects/VGA%20Projects/VGA%20Text%20Generation

module vga_controller(
    input clk_100MHz,
    input reset,
    output video_on,
    output hsync,
    output vsync, 
    output clk_25MHz, // 25 MHz clock with divider
    output [9:0] x, // pixel count/position of pixel x (0-799)
    output [9:0] y // pixel count/position of pixel y (0-524)
    );
    
    // Based on VGA standards found at vesa.org for 640x480 resolution
    // total horizontal width of screen = 800 pixels
    parameter HD = 640; // horizontal display area witdh
    parameter HF = 48; // horizontal front porch width
    parameter HB = 16; // horizontal back porch width
    parameter HR = 96; // horizontal retrace width
    parameter HMAX = HD+HF+HB+HR-1; // max value of horizontal counter = 799
    
    // total vertical length of screen = 525 pixels
    parameter VD = 480; // vertical display area length
    parameter VF = 10; // vertical front porch length
    parameter VB = 33; // vertical back porch length
    parameter VR = 2; // vertical retrace length
    parameter VMAX = VD+VF+VB+VR-1; // max value of vertical counter = 524   
    
    // clock divider from 100 MHz to 25 MHz
	reg  [1:0] r_25MHz;
	wire w_25MHz;
	always @(posedge clk_100MHz or posedge reset) begin
		if(reset)
		  r_25MHz <= 0;
		else
		  r_25MHz <= r_25MHz + 1;
	end 
	assign w_25MHz = (r_25MHz == 0) ? 1 : 0; // assert tick 1/4 of the time
    
    // counter registers and output buffers
    reg [9:0] h_count_reg, h_count_next;
    reg [9:0] v_count_reg, v_count_next;
    reg v_sync_reg, h_sync_reg;
    wire v_sync_next, h_sync_next;
    
    // register Control
    always @(posedge clk_100MHz or posedge reset) begin
        if(reset) begin
            v_count_reg <= 0;
            h_count_reg <= 0;
            v_sync_reg  <= 1'b0;
            h_sync_reg  <= 1'b0;
        end else begin
            v_count_reg <= v_count_next;
            h_count_reg <= h_count_next;
            v_sync_reg  <= v_sync_next;
            h_sync_reg  <= h_sync_next;
        end
    end
         
    // horizontal counter/scan
    always @(posedge w_25MHz or posedge reset)
        if(reset)
            h_count_next = 0;
        else
            if(h_count_reg == HMAX)
                h_count_next = 0;
            else
                h_count_next = h_count_reg + 1;         
  
    // vertical counter/scan
    always @(posedge w_25MHz or posedge reset)
        if(reset)
            v_count_next = 0;
        else
            if(h_count_reg == HMAX)
                if((v_count_reg == VMAX))
                    v_count_next = 0;
                else
                    v_count_next = v_count_reg + 1;
        
    // h_sync_next asserted within the horizontal retrace area
    assign h_sync_next = (h_count_reg >= (HD+HB) && h_count_reg <= (HD+HB+HR-1));
    
    // v_sync_next asserted within the vertical retrace area
    assign v_sync_next = (v_count_reg >= (VD+VB) && v_count_reg <= (VD+VB+VR-1));
    
    // video ON/OFF (ON while pixel counts are within the display area)
    assign video_on = (h_count_reg < HD) && (v_count_reg < VD); // 0-639 and 0-479 respectively
            
    // outputs
    assign hsync = h_sync_reg;
    assign vsync = v_sync_reg;
    assign x = h_count_reg;
    assign y = v_count_reg;
    assign clk_25MHz = w_25MHz;
            
endmodule
