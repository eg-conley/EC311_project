`timescale 1ns / 1ps
// created with references from https://github.com/FPGADude/Digital-Design/tree/main/FPGA%20Projects/VGA%20Projects/VGA%20Text%20Generation

module level_3_display(
    input clk,
    input video_on,
    input [9:0] x, y,
    input [7:0] letter,
    output reg [11:0] rgb
    );

    // Declare variables
    wire [10:0] rom_addr;
    reg [6:0] ascii_char;
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
    always@(*)begin
        ascii_char = 
        // "LEVEL 3" at y = 152 to 168
        ((x >= 296 && x < 304) && (y >= 152 && y < 168)) ? 7'h4c : 
        ((x >= 304 && x < 312) && (y >= 152 && y < 168)) ? 7'h45 : 
        ((x >= 312 && x < 320) && (y >= 152 && y < 168)) ? 7'h56 : 
        ((x >= 320 && x < 328) && (y >= 152 && y < 168)) ? 7'h45 : 
        ((x >= 328 && x < 336) && (y >= 152 && y < 168)) ? 7'h4c : 
        ((x >= 336 && x < 344) && (y >= 152 && y < 168)) ? 7'h20 : 
        ((x >= 344 && x < 352) && (y >= 152 && y < 168)) ? 7'h33 : 
        
        // "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG" centered on screen width 640 at y = 200 to 216
        ((x >= 144 && x < 152) && (y >= 216 && y < 232)) ? 7'h54 : // T
        ((x >= 152 && x < 160) && (y >= 216 && y < 232)) ? 7'h48 : // H
        ((x >= 160 && x < 168) && (y >= 216 && y < 232)) ? 7'h45 : // E
        ((x >= 168 && x < 176) && (y >= 216 && y < 232)) ? 7'h20 : // Space
        ((x >= 176 && x < 184) && (y >= 216 && y < 232)) ? 7'h51 : // Q
        ((x >= 184 && x < 192) && (y >= 216 && y < 232)) ? 7'h55 : // U
        ((x >= 192 && x < 200) && (y >= 216 && y < 232)) ? 7'h49 : // I
        ((x >= 200 && x < 208) && (y >= 216 && y < 232)) ? 7'h43 : // C
        ((x >= 208 && x < 216) && (y >= 216 && y < 232)) ? 7'h4B : // K
        ((x >= 216 && x < 224) && (y >= 216 && y < 232)) ? 7'h20 : // Space
        ((x >= 224 && x < 232) && (y >= 216 && y < 232)) ? 7'h42 : // B
        ((x >= 232 && x < 240) && (y >= 216 && y < 232)) ? 7'h52 : // R
        ((x >= 240 && x < 248) && (y >= 216 && y < 232)) ? 7'h4F : // O
        ((x >= 248 && x < 256) && (y >= 216 && y < 232)) ? 7'h57 : // W
        ((x >= 256 && x < 264) && (y >= 216 && y < 232)) ? 7'h4E : // N
        ((x >= 264 && x < 272) && (y >= 216 && y < 232)) ? 7'h20 : // Space
        ((x >= 272 && x < 280) && (y >= 216 && y < 232)) ? 7'h46 : // F
        ((x >= 280 && x < 288) && (y >= 216 && y < 232)) ? 7'h4F : // O
        ((x >= 288 && x < 296) && (y >= 216 && y < 232)) ? 7'h58 : // X
        ((x >= 296 && x < 304) && (y >= 216 && y < 232)) ? 7'h20 : // Space
        ((x >= 304 && x < 312) && (y >= 216 && y < 232)) ? 7'h4A : // J
        ((x >= 312 && x < 320) && (y >= 216 && y < 232)) ? 7'h55 : // U
        ((x >= 320 && x < 328) && (y >= 216 && y < 232)) ? 7'h4D : // M
        ((x >= 328 && x < 336) && (y >= 216 && y < 232)) ? 7'h50 : // P
        ((x >= 336 && x < 344) && (y >= 216 && y < 232)) ? 7'h53 : // S
        ((x >= 344 && x < 352) && (y >= 216 && y < 232)) ? 7'h20 : // Space
        ((x >= 352 && x < 360) && (y >= 216 && y < 232)) ? 7'h4F : // O
        ((x >= 360 && x < 368) && (y >= 216 && y < 232)) ? 7'h56 : // V
        ((x >= 368 && x < 376) && (y >= 216 && y < 232)) ? 7'h45 : // E
        ((x >= 376 && x < 384) && (y >= 216 && y < 232)) ? 7'h52 : // R
        ((x >= 384 && x < 392) && (y >= 216 && y < 232)) ? 7'h20 : // Space
        ((x >= 392 && x < 400) && (y >= 216 && y < 232)) ? 7'h54 : // T
        ((x >= 400 && x < 408) && (y >= 216 && y < 232)) ? 7'h48 : // H
        ((x >= 408 && x < 416) && (y >= 216 && y < 232)) ? 7'h45 : // E
        ((x >= 416 && x < 424) && (y >= 216 && y < 232)) ? 7'h20 : // Space
        ((x >= 424 && x < 432) && (y >= 216 && y < 232)) ? 7'h4C : // L
        ((x >= 432 && x < 440) && (y >= 216 && y < 232)) ? 7'h41 : // A
        ((x >= 440 && x < 448) && (y >= 216 && y < 232)) ? 7'h5A : // Z
        ((x >= 448 && x < 456) && (y >= 216 && y < 232)) ? 7'h59 : // Y
        ((x >= 456 && x < 464) && (y >= 216 && y < 232)) ? 7'h20 : // Space
        ((x >= 464 && x < 472) && (y >= 216 && y < 232)) ? 7'h44 : // D
        ((x >= 472 && x < 480) && (y >= 216 && y < 232)) ? 7'h4F : // O
        ((x >= 480 && x < 488) && (y >= 216 && y < 232)) ? 7'h47 : // G
    
        7'h20; // 1 (for LOGIC or default to blank)
    end

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