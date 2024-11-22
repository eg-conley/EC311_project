`timescale 1ns / 1ps



module vga_top(clk, reset, vga_r, vga_g, vga_b, h_sync, v_sync);

    input clk, reset;
    
    output reg [3:0] vga_r, vga_g, vga_b; // r, g, b values
    output h_sync, v_sync;
    wire newClk, ledOn;
    
    clk_divider clkDiv (clk, reset, newClk);
    
    vga_controller vga_con (newClk, h_sync, v_sync, ledOn);
    
    always@(posedge newClk) begin
      vga_r <= 4'b0000;
      vga_g <= 4'b0000;
      vga_b <= 4'b0000;
      if(ledOn) begin
          vga_r <= 4'b1001;
          vga_g <= 4'b1111;
          vga_b <= 4'b1111;
      end  
      else begin
          vga_r <= 4'b0000;
          vga_g <= 4'b0000;
          vga_b <= 4'b0000;
      end
      
    end
    
endmodule
