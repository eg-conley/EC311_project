`timescale 1ns / 1ps
// created with references from https://github.com/FPGADude/Digital-Design/tree/main/FPGA%20Projects/VGA%20Projects/VGA%20Text%20Generation

module level_1_display(
    input clk,
    input video_on,
    input [9:0] x, y,
    input [7:0] letter,
    output reg [11:0] rgb
    );
    
    // Declare variables
    wire [10:0] rom_addr;
    wire [6:0] ascii_char;
    reg [3:0] char_row; // Row of the ASCII character in ROM
    wire [2:0] bit_addr; // Column of the ASCII character in ROM
    wire [7:0] rom_data; // Data from the ROM (character bits)
    wire ascii_bit;      // The actual bit of the character
    wire ascii_bit_on;   // Whether to display the bit or not

    // Instantiate the ASCII ROM (assuming it's already defined)
    ascii_rom rom(clk, rom_addr, rom_data);
    
    // Assign the address to the ROM (address = ASCII value + row)
    assign rom_addr = {ascii_char, char_row};   // ROM address is ascii code + row
    assign ascii_bit = rom_data[~bit_addr];     // Reverse bit order for the character
    
    // Hardcode the letter to display for level instructions

    assign ascii_char = 
    // "LEVEL" at y = 152 to 168
    ((x >= 296 && x < 304) && (y >= 152 && y < 168)) ? 7'h4c : // L
    ((x >= 304 && x < 312) && (y >= 152 && y < 168)) ? 7'h45 : // E
    ((x >= 312 && x < 320) && (y >= 152 && y < 168)) ? 7'h56 : // V
    ((x >= 320 && x < 328) && (y >= 152 && y < 168)) ? 7'h45 : // E
    ((x >= 328 && x < 336) && (y >= 152 && y < 168)) ? 7'h4c : // L
    ((x >= 336 && x < 344) && (y >= 152 && y < 168)) ? 7'h20 : // space
    ((x >= 344 && x < 352) && (y >= 152 && y < 168)) ? 7'h31 : // 1 (for LEVEL) 
    
    ((x >= 304 && x < 312) && (y >= 216 && y < 232)) ? 7'h4c : // L
    ((x >= 312 && x < 320) && (y >= 216 && y < 232)) ? 7'h4f : // O
    ((x >= 320 && x < 328) && (y >= 216 && y < 232)) ? 7'h47 : // G
    ((x >= 328 && x < 336) && (y >= 216 && y < 232)) ? 7'h49 : // I
    ((x >= 336 && x < 344) && (y >= 216 && y < 232)) ? 7'h43 : // C
    7'h20; // 1 (for LOGIC or default to blank)


    // Assign the row and column for the ASCII ROM
    always@(*) begin    
        if(y >= 152 && y < 232) begin
            char_row = y-200; 
        end
        else begin
            char_row = 0;
       end
    end
    
    assign bit_addr = x[2:0]; // Column of ASCII ROM (lower 3 bits of x-coordinate)

    // Determine if the current pixel should display an "on" bit from the ROM
    assign ascii_bit_on = ((x >= 100 && x < 500) && (y >= 100 && y < 300)) ? ascii_bit : 1'b0;

    // Logic to assign RGB values
    always @(posedge clk) begin
        if (~video_on)  // If not in the display region
            rgb = 12'h000; // Black (background off)
        else if (ascii_bit_on) // If the ASCII bit is on
            rgb = 12'h000; // Black (character pixels)
        else
            rgb = 12'hFFF; // White background
    end
endmodule