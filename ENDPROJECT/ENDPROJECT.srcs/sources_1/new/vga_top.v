`timescale 1ns / 1ps


module vga_top(
    input clk,               // 25 MHz clock input (or higher)
    input reset,             // Reset signal
    input [9:0] ascii_value, // ASCII value to display (for example, 101 for 'E')
    output [3:0] vga_color,  // VGA color output (for the pixel)
    output hsync,            // Horizontal sync signal
    output vsync             // Vertical sync signal
); 
    
    wire [9:0] x, y;          // VGA pixel coordinates
    wire video_on;            // Indicates if the pixel is in the visible area
    wire letter;              // Output from lettermap to decide whether to display letter
    
    clk_divider clk_div (
        .clk_in(clk_in),    // Higher frequency input clock (50 MHz)
        .reset(reset),      // Reset signal
        .clk_out(clk_out)   // Output clock (25 MHz)
    );
    
    // Instantiate VGA controller
    vga_controller vga_ctrl (
        .clk(clk),              // Pass clock signal to VGA controller
        .reset(reset),          // Reset signal to the VGA controller
        .x(x),                  // Current x pixel coordinate from VGA controller
        .y(y),                  // Current y pixel coordinate from VGA controller
        .hsync(hsync),          // Horizontal sync signal for VGA
        .vsync(vsync),          // Vertical sync signal for VGA
        .video_on(video_on)     // Video on signal, indicating if the pixel is in the visible area
    );

    // Instantiate lettermap to display letter 'E' based on ASCII value
    lettermap letter_mapper (
        .clk(clk),
        .height(7),              // Height of letter 'E' (7 rows)
        .width(5),               // Width of letter 'E' (5 columns)
        .xstart(100),            // Starting x position for the letter (for example)
        .ystart(100),            // Starting y position for the letter (for example)
        .x(x),                   // Current x position from VGA controller
        .y(y),                   // Current y position from VGA controller
        .ascii_value(ascii_value), // ASCII value of the letter to display (e.g., 101 for 'E')
        .letter(letter)          // Output signal indicating whether to display the letter
    );

    // Determine VGA color based on the letter signal (if video_on and letter are true, color white; else black)
    assign vga_color = (video_on && letter) ? 4'b1111 : 4'b0000;  // White for the letter, Black for background

endmodule