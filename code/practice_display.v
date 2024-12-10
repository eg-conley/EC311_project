`timescale 1ns / 1ps
// created with references from https://github.com/FPGADude/Digital-Design/tree/main/FPGA%20Projects/VGA%20Projects/VGA%20Text%20Generation

module practice_display(
    input clk,
    input video_on,
    input [9:0] x, y,
    input [7:0] letter,
    output reg [11:0] rgb
    );
    
    // declare variables
    wire [10:0] rom_addr; // ASCII value + row
    reg [6:0] ascii_char; // ASCII value (7 bit)
    wire [3:0] char_row; // row of ASCII char in ROM
    wire [2:0] bit_addr; // column of ASCII char in ROM
    wire [7:0] rom_data; // data from the ROM
    wire ascii_bit; // actual bit from ROM data
    wire ascii_bit_on; // display bit or not
    wire [7:0] this_letter = letter;
    
    // instantiate ASCII ROM
    ascii_rom rom(clk, rom_addr, rom_data);
      
    // assign the address to ROM (ASCII value + row)
    assign rom_addr = {ascii_char, char_row};
    assign ascii_bit = rom_data[~bit_addr]; // reverse bit order for the character

    // ASCII mapping
    always @* begin
        ascii_char = 7'h00;
        // check if ASCII character in display range
        if ((x >= 320 && x < 328) && (y >= 208 && y < 224)) begin
            case (this_letter)
                8'h41: ascii_char = 7'h41;  // A
                8'h42: ascii_char = 7'h42;  // B
                8'h43: ascii_char = 7'h43;  // C
                8'h44: ascii_char = 7'h44;  // D
                8'h45: ascii_char = 7'h45;  // E
                8'h46: ascii_char = 7'h46;  // F
                8'h47: ascii_char = 7'h47;  // G
                8'h48: ascii_char = 7'h48;  // H
                8'h49: ascii_char = 7'h49;  // I
                8'h4a: ascii_char = 7'h4a;  // J
                8'h4b: ascii_char = 7'h4b;  // K
                8'h4c: ascii_char = 7'h4c;  // L
                8'h4d: ascii_char = 7'h4d;  // M
                8'h4e: ascii_char = 7'h4e;  // N
                8'h4f: ascii_char = 7'h4f;  // O
                8'h50: ascii_char = 7'h50;  // P
                8'h51: ascii_char = 7'h51;  // Q
                8'h52: ascii_char = 7'h52;  // R
                8'h53: ascii_char = 7'h53;  // S
                8'h54: ascii_char = 7'h54;  // T
                8'h55: ascii_char = 7'h55;  // U
                8'h56: ascii_char = 7'h56;  // V
                8'h57: ascii_char = 7'h57;  // W
                8'h58: ascii_char = 7'h58;  // X
                8'h59: ascii_char = 7'h59;  // Y
                8'h5a: ascii_char = 7'h5a;  // Z
                default: ascii_char = 7'h00;  // undefined letter
            endcase
        end
    end
    
    // assign row and column for ASCII ROM
    assign char_row = y[3:0]; // row of ASCII ROM
    assign bit_addr = x[2:0]; // column of ASCII ROM
    
    // determine if the current pixel should display an "on" bit from the ROM
    assign ascii_bit_on = ((x >= 320 && x < 328) && (y >= 208 && y < 224)) ? ascii_bit : 1'b0;
    
    // RGB logic
    always @(posedge clk) begin
        if (~video_on)
            rgb = 12'h000; // black
        else if (ascii_bit_on)
            rgb = 12'h000; // black
        else
            rgb = 12'hFFF; // white
    end
    
endmodule
