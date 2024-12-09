`timescale 1ns / 1ps
// created with references from https://github.com/FPGADude/Digital-Design/tree/main/FPGA%20Projects/VGA%20Projects/VGA%20Text%20Generation

module start_page_display(
    input clk,
    input video_on,
    input [9:0] x, y,
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
    // "WELCOME MORSE CODER" at y = 200 to 216 (shifted to x = 232)
    ((x >= 232 && x < 240) && (y >= 200 && y < 216)) ? 7'h57 : // W
    ((x >= 240 && x < 248) && (y >= 200 && y < 216)) ? 7'h45 : // E
    ((x >= 248 && x < 256) && (y >= 200 && y < 216)) ? 7'h4C : // L
    ((x >= 256 && x < 264) && (y >= 200 && y < 216)) ? 7'h43 : // C
    ((x >= 264 && x < 272) && (y >= 200 && y < 216)) ? 7'h4F : // O
    ((x >= 272 && x < 280) && (y >= 200 && y < 216)) ? 7'h4D : // M
    ((x >= 280 && x < 288) && (y >= 200 && y < 216)) ? 7'h45 : // E
    ((x >= 288 && x < 296) && (y >= 200 && y < 216)) ? 7'h20 : // Space
    ((x >= 296 && x < 304) && (y >= 200 && y < 216)) ? 7'h4D : // M
    ((x >= 304 && x < 312) && (y >= 200 && y < 216)) ? 7'h4F : // O
    ((x >= 312 && x < 320) && (y >= 200 && y < 216)) ? 7'h52 : // R
    ((x >= 320 && x < 328) && (y >= 200 && y < 216)) ? 7'h53 : // S 
    ((x >= 328 && x < 336) && (y >= 200 && y < 216)) ? 7'h45 : // E
    ((x >= 336 && x < 344) && (y >= 200 && y < 216)) ? 7'h20 : // Space
    ((x >= 344 && x < 352) && (y >= 200 && y < 216)) ? 7'h43 : // C
    ((x >= 352 && x < 360) && (y >= 200 && y < 216)) ? 7'h4F : // O
    ((x >= 360 && x < 368) && (y >= 200 && y < 216)) ? 7'h44 : // D
    ((x >= 368 && x < 376) && (y >= 200 && y < 216)) ? 7'h45 : // E
    ((x >= 376 && x < 384) && (y >= 200 && y < 216)) ? 7'h52 : // R

    // "PRACTICE ESCAPE" at y = 248 to 264 (shifted down by 32 in y direction)
    ((x >= 208 && x < 216) && (y >= 248 && y < 264)) ? 7'h45 : // E
    ((x >= 216 && x < 224) && (y >= 248 && y < 264)) ? 7'h53 : // S
    ((x >= 224 && x < 232) && (y >= 248 && y < 264)) ? 7'h43 : // C
    ((x >= 232 && x < 240) && (y >= 248 && y < 264)) ? 7'h41 : // A
    ((x >= 240 && x < 248) && (y >= 248 && y < 264)) ? 7'h50 : // P
    ((x >= 248 && x < 256) && (y >= 248 && y < 264)) ? 7'h45 : // E
    ((x >= 256 && x < 264) && (y >= 248 && y < 264)) ? 7'h2e : // :
    ((x >= 264 && x < 272) && (y >= 248 && y < 264)) ? 7'h20 : // Space
    ((x >= 272 && x < 280) && (y >= 248 && y < 264)) ? 7'h20 : // Space
    ((x >= 280 && x < 288) && (y >= 248 && y < 264)) ? 7'h20 : // Space
    ((x >= 288 && x < 296) && (y >= 248 && y < 264)) ? 7'h20 : // Space
    ((x >= 296 && x < 304) && (y >= 248 && y < 264)) ? 7'h20 : // Space
    ((x >= 304 && x < 312) && (y >= 248 && y < 264)) ? 7'h20 : // Space
    ((x >= 312 && x < 320) && (y >= 248 && y < 264)) ? 7'h20 : // Space
    ((x >= 320 && x < 328) && (y >= 248 && y < 264)) ? 7'h20 : // Space
    ((x >= 328 && x < 336) && (y >= 248 && y < 264)) ? 7'h20 : // Space
    ((x >= 336 && x < 344) && (y >= 248 && y < 264)) ? 7'h50 : // P
    ((x >= 344 && x < 352) && (y >= 248 && y < 264)) ? 7'h52 : // R
    ((x >= 352 && x < 360) && (y >= 248 && y < 264)) ? 7'h41 : // A
    ((x >= 360 && x < 368) && (y >= 248 && y < 264)) ? 7'h43 : // C
    ((x >= 368 && x < 376) && (y >= 248 && y < 264)) ? 7'h54 : // T
    ((x >= 376 && x < 384) && (y >= 248 && y < 264)) ? 7'h49 : // I
    ((x >= 384 && x < 392) && (y >= 248 && y < 264)) ? 7'h43 : // C
    ((x >= 392 && x < 400) && (y >= 248 && y < 264)) ? 7'h45 : // E
    ((x >= 400 && x < 408) && (y >= 248 && y < 264)) ? 7'h2e : // :

    
    // "SWITCH 1" at y = 280 to 296 (starting at x = 336)
    ((x >= 336 && x < 344) && (y >= 280 && y < 296)) ? 7'h53 : // S
    ((x >= 344 && x < 352) && (y >= 280 && y < 296)) ? 7'h57 : // W
    ((x >= 352 && x < 360) && (y >= 280 && y < 296)) ? 7'h49 : // I
    ((x >= 360 && x < 368) && (y >= 280 && y < 296)) ? 7'h54 : // T
    ((x >= 368 && x < 376) && (y >= 280 && y < 296)) ? 7'h43 : // C
    ((x >= 376 && x < 384) && (y >= 280 && y < 296)) ? 7'h48 : // H
    ((x >= 384 && x < 392) && (y >= 280 && y < 296)) ? 7'h20 : // Space
    ((x >= 392 && x < 400) && (y >= 280 && y < 296)) ? 7'h30 : // 0
    
// "LEVEL 1 -> SWITCH 1" at y = 280 to 296 (starting at x = 144)
    ((x >= 144 && x < 152) && (y >= 280 && y < 296)) ? 7'h4C : // L
    ((x >= 152 && x < 160) && (y >= 280 && y < 296)) ? 7'h45 : // E
    ((x >= 160 && x < 168) && (y >= 280 && y < 296)) ? 7'h56 : // V
    ((x >= 168 && x < 176) && (y >= 280 && y < 296)) ? 7'h45 : // E
    ((x >= 176 && x < 184) && (y >= 280 && y < 296)) ? 7'h4C : // L
    ((x >= 184 && x < 192) && (y >= 280 && y < 296)) ? 7'h20 : // Space
    ((x >= 192 && x < 200) && (y >= 280 && y < 296)) ? 7'h31 : // 1
    ((x >= 200 && x < 208) && (y >= 280 && y < 296)) ? 7'h20 : // Space
    ((x >= 208 && x < 216) && (y >= 280 && y < 296)) ? 7'h2F : // arrow
    ((x >= 216 && x < 224) && (y >= 280 && y < 296)) ? 7'h20 : // Space
    ((x >= 224 && x < 232) && (y >= 280 && y < 296)) ? 7'h53 : // S
    ((x >= 232 && x < 240) && (y >= 280 && y < 296)) ? 7'h57 : // W
    ((x >= 240 && x < 248) && (y >= 280 && y < 296)) ? 7'h49 : // I
    ((x >= 248 && x < 256) && (y >= 280 && y < 296)) ? 7'h54 : // T
    ((x >= 256 && x < 264) && (y >= 280 && y < 296)) ? 7'h43 : // C
    ((x >= 264 && x < 272) && (y >= 280 && y < 296)) ? 7'h48 : // H
    ((x >= 272 && x < 280) && (y >= 280 && y < 296)) ? 7'h20 : // Space
    ((x >= 280 && x < 288) && (y >= 280 && y < 296)) ? 7'h31 : // 1
    
// "LEVEL 2 -> SWITCH 2" at y = 296 to 312 (starting at x = 144)
    ((x >= 144 && x < 152) && (y >= 296 && y < 312)) ? 7'h4C : // L
    ((x >= 152 && x < 160) && (y >= 296 && y < 312)) ? 7'h45 : // E
    ((x >= 160 && x < 168) && (y >= 296 && y < 312)) ? 7'h56 : // V
    ((x >= 168 && x < 176) && (y >= 296 && y < 312)) ? 7'h45 : // E
    ((x >= 176 && x < 184) && (y >= 296 && y < 312)) ? 7'h4C : // L
    ((x >= 184 && x < 192) && (y >= 296 && y < 312)) ? 7'h20 : // Space
    ((x >= 192 && x < 200) && (y >= 296 && y < 312)) ? 7'h32 : // 2
    ((x >= 200 && x < 208) && (y >= 296 && y < 312)) ? 7'h20 : // Space
    ((x >= 208 && x < 216) && (y >= 296 && y < 312)) ? 7'h2F : // arrow
    ((x >= 216 && x < 224) && (y >= 296 && y < 312)) ? 7'h20 : // Space
    ((x >= 224 && x < 232) && (y >= 296 && y < 312)) ? 7'h53 : // S
    ((x >= 232 && x < 240) && (y >= 296 && y < 312)) ? 7'h57 : // W
    ((x >= 240 && x < 248) && (y >= 296 && y < 312)) ? 7'h49 : // I
    ((x >= 248 && x < 256) && (y >= 296 && y < 312)) ? 7'h54 : // T
    ((x >= 256 && x < 264) && (y >= 296 && y < 312)) ? 7'h43 : // C
    ((x >= 264 && x < 272) && (y >= 296 && y < 312)) ? 7'h48 : // H
    ((x >= 272 && x < 280) && (y >= 296 && y < 312)) ? 7'h20 : // Space
    ((x >= 280 && x < 288) && (y >= 296 && y < 312)) ? 7'h32 : // 2

// "LEVEL 3 -> SWITCH 3" at y = 312 to 328 (starting at x = 144)
    ((x >= 144 && x < 152) && (y >= 312 && y < 328)) ? 7'h4C : // L
    ((x >= 152 && x < 160) && (y >= 312 && y < 328)) ? 7'h45 : // E
    ((x >= 160 && x < 168) && (y >= 312 && y < 328)) ? 7'h56 : // V
    ((x >= 168 && x < 176) && (y >= 312 && y < 328)) ? 7'h45 : // E
    ((x >= 176 && x < 184) && (y >= 312 && y < 328)) ? 7'h4C : // L
    ((x >= 184 && x < 192) && (y >= 312 && y < 328)) ? 7'h20 : // Space
    ((x >= 192 && x < 200) && (y >= 312 && y < 328)) ? 7'h33 : // 3
    ((x >= 200 && x < 208) && (y >= 312 && y < 328)) ? 7'h20 : // Space
    ((x >= 208 && x < 216) && (y >= 312 && y < 328)) ? 7'h2F : // arrow
    ((x >= 216 && x < 224) && (y >= 312 && y < 328)) ? 7'h20 : // Space
    ((x >= 224 && x < 232) && (y >= 312 && y < 328)) ? 7'h53 : // S
    ((x >= 232 && x < 240) && (y >= 312 && y < 328)) ? 7'h57 : // W
    ((x >= 240 && x < 248) && (y >= 312 && y < 328)) ? 7'h49 : // I
    ((x >= 248 && x < 256) && (y >= 312 && y < 328)) ? 7'h54 : // T
    ((x >= 256 && x < 264) && (y >= 312 && y < 328)) ? 7'h43 : // C
    ((x >= 264 && x < 272) && (y >= 312 && y < 328)) ? 7'h48 : // H
    ((x >= 272 && x < 280) && (y >= 312 && y < 328)) ? 7'h20 : // Space
    ((x >= 280 && x < 288) && (y >= 312 && y < 328)) ? 7'h33 : // 3
    
    7'h20; // Default (blank space)

    
    // Assign the row and column for the ASCII ROM
    // assign char_row = y[3:0]; // Row of ASCII ROM (lower 4 bits of y-coordinate)
    always@(*)
    begin    
        if(y>=200 && y < 328)
        begin
            char_row = y-200;
        end    
        else 
        begin
            char_row = 0;
            
       end
    end
    
    assign bit_addr = x[2:0]; // Column of ASCII ROM (lower 3 bits of x-coordinate)

    // Determine if the current pixel should display an "on" bit from the ROM
    // assign ascii_bit_on = ((x >= 296 && x < 352) && (y >= 200 && y < 232)) ? ascii_bit : 1'b0;
    assign ascii_bit_on = ((x >= 120 && x < 500) && (y >= 192 && y < 350)) ? ascii_bit : 1'b0;

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
