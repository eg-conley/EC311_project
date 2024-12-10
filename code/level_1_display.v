`timescale 1ns / 1ps
// created with references from https://github.com/FPGADude/Digital-Design/tree/main/FPGA%20Projects/VGA%20Projects/VGA%20Text%20Generation

module level_1_display(
    input clk,
    input reset,
    input video_on,
    input [9:0] x, y,
    input [7:0] letter,
    input [7:0] counter, // number of total letters
    output reg lvl_won, // win flag
    output reg [11:0] rgb
    );
    
    // declare variables
    wire [10:0] rom_addr; // ASCII value + row
    wire [6:0] ascii_char; // ASCII value (7 bit)
    reg [3:0] char_row; // row of ASCII char in ROM
    wire [2:0] bit_addr; // column of ASCII char in ROM
    wire [7:0] rom_data; // data from the ROM
    wire ascii_bit; // actual bit from ROM data
    wire ascii_bit_on; // display bit or not

    // instantiate ASCII ROM
    ascii_rom rom(clk, rom_addr, rom_data);
      
    // assign the address to ROM (ASCII value + row)
    assign rom_addr = {ascii_char, char_row};
    assign ascii_bit = rom_data[~bit_addr]; // reverse bit order for the character
    
    // level setup
    assign ascii_char = 
    // "LEVEL 1" at y = 152 to 168
    ((x >= 296 && x < 304) && (y >= 152 && y < 168)) ? 7'h4c : // L
    ((x >= 304 && x < 312) && (y >= 152 && y < 168)) ? 7'h45 : // E
    ((x >= 312 && x < 320) && (y >= 152 && y < 168)) ? 7'h56 : // V
    ((x >= 320 && x < 328) && (y >= 152 && y < 168)) ? 7'h45 : // E
    ((x >= 328 && x < 336) && (y >= 152 && y < 168)) ? 7'h4c : // L
    ((x >= 336 && x < 344) && (y >= 152 && y < 168)) ? 7'h20 : // space
    ((x >= 344 && x < 352) && (y >= 152 && y < 168)) ? 7'h31 : // 1 (for LEVEL) 
    
    // "LOGIC" at y = 216 to 168
    ((x >= 304 && x < 312) && (y >= 216 && y < 232)) ? 7'h4c : // L
    ((x >= 312 && x < 320) && (y >= 216 && y < 232)) ? 7'h4f : // O
    ((x >= 320 && x < 328) && (y >= 216 && y < 232)) ? 7'h47 : // G
    ((x >= 328 && x < 336) && (y >= 216 && y < 232)) ? 7'h49 : // I
    ((x >= 336 && x < 344) && (y >= 216 && y < 232)) ? 7'h43 : // C
    
    // USER INPUT LINE
    ((x >= 304 && x < 312) && (y >= 232 && y < 248)) ? 7'h4c : // L
    ((x >= 312 && x < 320) && (y >= 232 && y < 248)) ? 7'h4f : // O
    ((x >= 320 && x < 328) && (y >= 232 && y < 248)) ? 7'h47 : // G
    ((x >= 328 && x < 336) && (y >= 232 && y < 248)) ? 7'h49 : // I
    ((x >= 336 && x < 344) && (y >= 232 && y < 248)) ? 7'h43 : // C
    7'h20; // default (blank space)

    // assign row and column for ASCII ROM
    always@(*) begin
        if(y >= 152 && y < 248) begin
            char_row = y-200; 
        end else begin
            char_row = 0;
       end
    end
    assign bit_addr = x[2:0];
    
    // start of the USER input matching logic 
    wire ascii_L, ascii_O, ascii_G, ascii_I, ascii_C;
    
    // initialize everything as 0 at start of level
    reg [9:0] prevCheck; // to keep track of letters to display
    reg [4:0] lettersRight; // to keep track of user input corresponding to expected
    initial begin
        prevCheck = 0;
        lettersRight = 0;
        lvl_won = 0; // false     
    end
    
    // assign constraints for letters
    assign ascii_bit_on = ((x >= 192 && x < 448) && (y >= 152 && y < 232)) ? ascii_bit : 1'b0;
    assign ascii_L = ((x >= 304 && x < 312) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_O = ((x >= 312 && x < 320) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_G = ((x >= 320 && x < 328) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_I = ((x >= 328 && x < 336) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_C = ((x >= 336 && x < 344) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;

    // RGB logic
    always @(posedge clk) begin
        if(counter == 6 && lettersRight == 5'b11111)
            lvl_won <= 1;
        
        if(reset) begin
            prevCheck = 10'b0;
            lvl_won <= 0;
        end
        
        if (~video_on)
            rgb = 12'h000; // black
        else if (ascii_bit_on)
            rgb = 12'h000; // black
        else if((ascii_L && counter == 1 && letter == "L") || (ascii_L && prevCheck[0] == 1)) begin
            rgb = 12'h0F0; // green
            prevCheck[0] <= 1;
            lettersRight[0] = 1;
        end else if((ascii_L && counter == 1 && letter != "L") || (ascii_L && prevCheck[1] == 1)) begin
            rgb = 12'hF00; // red
            prevCheck[1] <= 1;
        end else if((ascii_O && counter == 2 && letter == "O") || (ascii_O && prevCheck[2] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[2] <= 1;
            lettersRight[1] = 1;
        end else if((ascii_O && counter == 2 && letter != "O") || (ascii_O && prevCheck[3] == 1)) begin
            rgb = 12'hF00;
            prevCheck[3] <= 1;
        end else if((ascii_G && counter == 3 && letter == "G") || (ascii_G && prevCheck[4] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[4] <= 1;
            lettersRight[2] = 1;
        end else if((ascii_G && counter == 3 && letter != "G") || (ascii_G && prevCheck[5] == 1)) begin
            rgb = 12'hF00;
            prevCheck[5] <= 1;
        end else if((ascii_I && counter == 4 && letter == "I") || (ascii_I && prevCheck[6] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[6] <= 1;
            lettersRight[3] = 1;
        end else if((ascii_I && counter == 4 && letter != "I") || (ascii_I && prevCheck[7] == 1)) begin
            rgb = 12'hF00;
            prevCheck[7] <= 1;
        end else if((ascii_C && counter == 5 && letter == "C") || (ascii_C && prevCheck[8] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[8] <= 1;
            lettersRight[4] = 1;
        end else if((ascii_C && counter == 5 && letter != "C") || (ascii_C && prevCheck[9] == 1)) begin
            rgb = 12'hF00;
            prevCheck[9] <= 1;
        end else
            rgb = 12'hFFF; // white
    end
    
endmodule
