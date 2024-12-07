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
     // "WELCOME MORSE CODER" centered over "PRACTICE ESCAPE" at y = 200 to 216
    ((x >= 276 && x < 284) && (y >= 200 && y < 216)) ? 7'h57 : // W
    ((x >= 284 && x < 292) && (y >= 200 && y < 216)) ? 7'h45 : // E
    ((x >= 292 && x < 300) && (y >= 200 && y < 216)) ? 7'h4C : // L
    ((x >= 300 && x < 308) && (y >= 200 && y < 216)) ? 7'h43 : // C
    ((x >= 308 && x < 316) && (y >= 200 && y < 216)) ? 7'h4F : // O
    ((x >= 316 && x < 324) && (y >= 200 && y < 216)) ? 7'h4D : // M
    ((x >= 324 && x < 332) && (y >= 200 && y < 216)) ? 7'h45 : // E
    ((x >= 332 && x < 340) && (y >= 200 && y < 216)) ? 7'h20 : // Space
    ((x >= 340 && x < 348) && (y >= 200 && y < 216)) ? 7'h4D : // M
    ((x >= 348 && x < 356) && (y >= 200 && y < 216)) ? 7'h4F : // O
    ((x >= 356 && x < 364) && (y >= 200 && y < 216)) ? 7'h52 : // R
    ((x >= 364 && x < 372) && (y >= 200 && y < 216)) ? 7'h53 : // S
    ((x >= 372 && x < 380) && (y >= 200 && y < 216)) ? 7'h45 : // E
    ((x >= 380 && x < 388) && (y >= 200 && y < 216)) ? 7'h20 : // Space
    ((x >= 388 && x < 396) && (y >= 200 && y < 216)) ? 7'h43 : // C
    ((x >= 396 && x < 404) && (y >= 200 && y < 216)) ? 7'h4F : // O
    ((x >= 404 && x < 412) && (y >= 200 && y < 216)) ? 7'h44 : // D
    ((x >= 412 && x < 420) && (y >= 200 && y < 216)) ? 7'h45 : // E
    ((x >= 420 && x < 428) && (y >= 200 && y < 216)) ? 7'h52 : // R

    // "PRACTICE ESCAPE" at y = 216 to 232
    ((x >= 280 && x < 288) && (y >= 216 && y < 232)) ? 7'h50 : // P
    ((x >= 288 && x < 296) && (y >= 216 && y < 232)) ? 7'h52 : // R
    ((x >= 296 && x < 304) && (y >= 216 && y < 232)) ? 7'h41 : // A
    ((x >= 304 && x < 312) && (y >= 216 && y < 232)) ? 7'h43 : // C
    ((x >= 312 && x < 320) && (y >= 216 && y < 232)) ? 7'h54 : // T
    ((x >= 320 && x < 328) && (y >= 216 && y < 232)) ? 7'h49 : // I
    ((x >= 328 && x < 336) && (y >= 216 && y < 232)) ? 7'h43 : // C
    ((x >= 336 && x < 344) && (y >= 216 && y < 232)) ? 7'h45 : // E
    ((x >= 344 && x < 352) && (y >= 216 && y < 232)) ? 7'h20 : // Space
    ((x >= 352 && x < 360) && (y >= 216 && y < 232)) ? 7'h20 : // Space
    ((x >= 360 && x < 368) && (y >= 216 && y < 232)) ? 7'h20 : // Space
    ((x >= 368 && x < 376) && (y >= 216 && y < 232)) ? 7'h20 : // Space
    ((x >= 376 && x < 384) && (y >= 216 && y < 232)) ? 7'h20 : // Space
    ((x >= 384 && x < 392) && (y >= 216 && y < 232)) ? 7'h20 : // Space
    ((x >= 392 && x < 400) && (y >= 216 && y < 232)) ? 7'h20 : // Space
    ((x >= 400 && x < 408) && (y >= 216 && y < 232)) ? 7'h45 : // E
    ((x >= 408 && x < 416) && (y >= 216 && y < 232)) ? 7'h53 : // S
    ((x >= 416 && x < 424) && (y >= 216 && y < 232)) ? 7'h43 : // C
    ((x >= 424 && x < 432) && (y >= 216 && y < 232)) ? 7'h41 : // A
    ((x >= 432 && x < 440) && (y >= 216 && y < 232)) ? 7'h50 : // P
    ((x >= 440 && x < 448) && (y >= 216 && y < 232)) ? 7'h45 : // E

    // ".    -" at y = 232 to 240
    ((x >= 280 && x < 288) && (y >= 232 && y < 240)) ? 7'h20 : // space
    ((x >= 288 && x < 296) && (y >= 232 && y < 240)) ? 7'h20 : // space
    ((x >= 296 && x < 304) && (y >= 232 && y < 240)) ? 7'h20 : // space
    ((x >= 304 && x < 312) && (y >= 232 && y < 240)) ? 7'h20 : // space
    ((x >= 312 && x < 320) && (y >= 232 && y < 240)) ? 7'h2e : // .
    ((x >= 320 && x < 328) && (y >= 232 && y < 240)) ? 7'h20 : // space
    ((x >= 328 && x < 336) && (y >= 232 && y < 240)) ? 7'h20 : // space
    ((x >= 336 && x < 344) && (y >= 232 && y < 240)) ? 7'h20 : // space
    ((x >= 344 && x < 352) && (y >= 232 && y < 240)) ? 7'h20 : // space
    ((x >= 352 && x < 360) && (y >= 232 && y < 240)) ? 7'h20 : // space
    ((x >= 360 && x < 368) && (y >= 232 && y < 240)) ? 7'h20 : // space
    ((x >= 368 && x < 376) && (y >= 232 && y < 240)) ? 7'h20 : // space
    ((x >= 376 && x < 384) && (y >= 232 && y < 240)) ? 7'h20 : // space
    ((x >= 384 && x < 392) && (y >= 232 && y < 240)) ? 7'h20 : // space
    ((x >= 392 && x < 400) && (y >= 232 && y < 240)) ? 7'h20 : // space
    ((x >= 400 && x < 408) && (y >= 232 && y < 240)) ? 7'h20 : // space
    ((x >= 408 && x < 416) && (y >= 232 && y < 240)) ? 7'h20 : // space
    ((x >= 416 && x < 424) && (y >= 232 && y < 240)) ? 7'h2d : // -
    ((x >= 424 && x < 432) && (y >= 232 && y < 240)) ? 7'h20 : // space
    ((x >= 432 && x < 440) && (y >= 232 && y < 240)) ? 7'h20 : // space
    ((x >= 440 && x < 448) && (y >= 232 && y < 240)) ? 7'h20 : 7'h20; // space
    

    // Assign the row and column for the ASCII ROM
    always@(*) begin
        if( y >= 200 && y < 240) begin
            char_row = y-200;
        end
        else begin
            char_row = 0;  
       end
    end
    
    assign bit_addr = x[2:0]; // Column of ASCII ROM (lower 3 bits of x-coordinate)

    // Determine if the current pixel should display an "on" bit from the ROM
    assign ascii_bit_on = ((x >= 100 && x < 550) && (y >= 100 && y < 250)) ? ascii_bit : 1'b0;

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

