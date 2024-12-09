`timescale 1ns / 1ps
// created with references from https://github.com/FPGADude/Digital-Design/tree/main/FPGA%20Projects/VGA%20Projects/VGA%20Text%20Generation

module level_2_display(
    input clk,
    input reset,
    input video_on,
    input [9:0] x, y,
    input [7:0] letter,
    input [7:0] counter,
    output reg lvl_won,
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
    // "LEVEL 2" at y = 152 to 168
    ((x >= 296 && x < 304) && (y >= 152 && y < 168)) ? 7'h4c : 
    ((x >= 304 && x < 312) && (y >= 152 && y < 168)) ? 7'h45 : 
    ((x >= 312 && x < 320) && (y >= 152 && y < 168)) ? 7'h56 : 
    ((x >= 320 && x < 328) && (y >= 152 && y < 168)) ? 7'h45 : 
    ((x >= 328 && x < 336) && (y >= 152 && y < 168)) ? 7'h4c : 
    ((x >= 336 && x < 344) && (y >= 152 && y < 168)) ? 7'h20 : 
    ((x >= 344 && x < 352) && (y >= 152 && y < 168)) ? 7'h32 : 
    
    // "BU" 
    ((x >= 280 && x < 288) && (y >= 216 && y < 232)) ? 7'h42 : 
    ((x >= 288 && x < 296) && (y >= 216 && y < 232)) ? 7'h55 : 
    ((x >= 296 && x < 304) && (y >= 216 && y < 232)) ? 7'h20 : 
    
    // "ENGINEERING" 
    ((x >= 304 && x < 312) && (y >= 216 && y < 232)) ? 7'h45 : 
    ((x >= 312 && x < 320) && (y >= 216 && y < 232)) ? 7'h4e : 
    ((x >= 320 && x < 328) && (y >= 216 && y < 232)) ? 7'h47 : 
    ((x >= 328 && x < 336) && (y >= 216 && y < 232)) ? 7'h49 : 
    ((x >= 336 && x < 344) && (y >= 216 && y < 232)) ? 7'h4e : // N
    ((x >= 344 && x < 352) && (y >= 216 && y < 232)) ? 7'h45 : 
    ((x >= 352 && x < 360) && (y >= 216 && y < 232)) ? 7'h45 : 
    ((x >= 360 && x < 368) && (y >= 216 && y < 232)) ? 7'h52 : 
    ((x >= 368 && x < 376) && (y >= 216 && y < 232)) ? 7'h49 : 
    ((x >= 376 && x < 384) && (y >= 216 && y < 232)) ? 7'h4e : 
    ((x >= 384 && x < 392) && (y >= 216 && y < 232)) ? 7'h47 : 

    
    // "BU" 
    ((x >= 280 && x < 288) && (y >= 232 && y < 248)) ? 7'h42 : // B
    ((x >= 288 && x < 296) && (y >= 232 && y < 248)) ? 7'h55 : // U
    ((x >= 296 && x < 304) && (y >= 232 && y < 248)) ? 7'h20 : // space
    // "ENGINEERING"
    ((x >= 304 && x < 312) && (y >= 232 && y < 248)) ? 7'h45 : // E
    ((x >= 312 && x < 320) && (y >= 232 && y < 248)) ? 7'h4e : // N
    ((x >= 320 && x < 328) && (y >= 232 && y < 248)) ? 7'h47 : // G
    ((x >= 328 && x < 336) && (y >= 232 && y < 248)) ? 7'h49 : // I
    ((x >= 336 && x < 344) && (y >= 232 && y < 248)) ? 7'h4e : // N
    ((x >= 344 && x < 352) && (y >= 232 && y < 248)) ? 7'h45 : // E
    ((x >= 352 && x < 360) && (y >= 232 && y < 248)) ? 7'h45 : // E
    ((x >= 360 && x < 368) && (y >= 232 && y < 248)) ? 7'h52 : // R
    ((x >= 368 && x < 376) && (y >= 232 && y < 248)) ? 7'h49 : // I
    ((x >= 376 && x < 384) && (y >= 232 && y < 248)) ? 7'h4e : // N
    ((x >= 384 && x < 392) && (y >= 232 && y < 248)) ? 7'h47 : // G
    7'h00;

    // Assign the row and column for the ASCII ROM
    always@(*) begin    
        if(y >= 152 && y < 248) begin
            char_row = y-200;
        end    
        else begin
            char_row = 0;
       end
    end
    
    assign bit_addr = x[2:0]; // Column of ASCII ROM (lower 3 bits of x-coordinate)
    reg [27:0] prevCheck;
    reg [13:0] lettersRight;
    initial prevCheck = 0;
    initial lettersRight = 0;
    initial lvl_won = 0;
    
    wire ascii_B, ascii_U, ascii_Space, ascii_E1, ascii_N1, ascii_G1, ascii_I1, ascii_N2, ascii_E2, ascii_E3, ascii_R, ascii_I2, ascii_N3, ascii_G2;

    // Determine if the current pixel should display an "on" bit from the ROM
    assign ascii_bit_on1 = ((x >= 295 && x < 352) && (y >= 152 && y < 168)) ? ascii_bit : 1'b0;
    assign ascii_bit_on2 = ((x >= 280 && x < 392) && (y >= 216 && y < 232)) ? ascii_bit : 1'b0;
    
    assign ascii_B = ((x >= 280 && x < 288) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_U = ((x >= 288 && x < 296) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_Space = ((x >= 296 && x < 304) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_E1 = ((x >= 304 && x < 312) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_N1 = ((x >= 312 && x < 320) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_G1 = ((x >= 320 && x < 328) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_I1 = ((x >= 328 && x < 336) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_N2 = ((x >= 336 && x < 344) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_E2 = ((x >= 344 && x < 352) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_E3 = ((x >= 352 && x < 360) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_R =  ((x >= 360 && x < 368) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_I2 = ((x >= 368 && x < 376) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_N3 = ((x >= 376 && x < 384) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_G2 = ((x >= 384 && x < 392) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;

    // Logic to assign RGB values
    always @(posedge clk) begin
        if(counter == 15 && lettersRight == 14'b11111111111111)
            lvl_won <= 1;
        else
            lvl_won <= 0;
            
        if(reset) begin
            prevCheck = 10'b0;
            lvl_won <= 0;
        end
        if(reset) begin
            prevCheck = 28'b0;
        end
        if (~video_on)  // If not in the display region
            rgb = 12'h000; // Black (background off)
        else if (ascii_bit_on1 || ascii_bit_on2) // If the ASCII bit is on
            rgb = 12'h000; // Black (character pixels)
        else if ((ascii_B && counter == 1 && letter == "B") || (ascii_B && prevCheck[0] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[0] <= 1;
            lettersRight[0] = 1;
        end else if ((ascii_B && counter == 1 && letter != "B") || (ascii_B && prevCheck[1] == 1)) begin
            rgb = 12'hF00;
            prevCheck[1] <= 1;
        end else if ((ascii_U && counter == 2 && letter == "U") || (ascii_U && prevCheck[2] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[2] <= 1;
            lettersRight[1] = 1;
        end else if ((ascii_U && counter == 2 && letter != "U") || (ascii_U && prevCheck[3] == 1)) begin
            rgb = 12'hF00;
            prevCheck[3] <= 1;
        end else if ((ascii_Space && counter == 3 && letter == " ") || (ascii_Space && prevCheck[4] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[4] <= 1;
            lettersRight[2] = 1;
        end else if ((ascii_Space && counter == 3 && letter != " ") || (ascii_Space && prevCheck[5] == 1)) begin
            rgb = 12'hF00;
            prevCheck[5] <= 1;
        end else if ((ascii_E1 && counter == 4 && letter == "E") || (ascii_E1 && prevCheck[6] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[6] <= 1;
            lettersRight[3] = 1;
        end else if ((ascii_E1 && counter == 4 && letter != "E") || (ascii_E1 && prevCheck[7] == 1)) begin
            rgb = 12'hF00;
            prevCheck[7] <= 1;
        end else if ((ascii_N1 && counter == 5 && letter == "N") || (ascii_N1 && prevCheck[8] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[8] <= 1;
            lettersRight[4] = 1;
        end else if ((ascii_N1 && counter == 5 && letter != "N") || (ascii_N1 && prevCheck[9] == 1)) begin
            rgb = 12'hF00;
            prevCheck[9] <= 1;
        end else if ((ascii_G1 && counter == 6 && letter == "G") || (ascii_G1 && prevCheck[10] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[10] <= 1;
            lettersRight[5] = 1;
        end else if ((ascii_G1 && counter == 6 && letter != "G") || (ascii_G1 && prevCheck[11] == 1)) begin
            rgb = 12'hF00;
            prevCheck[11] <= 1;
        end else if ((ascii_I1 && counter == 7 && letter == "I") || (ascii_I1 && prevCheck[12] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[12] <= 1;
            lettersRight[6] = 1;
        end else if ((ascii_I1 && counter == 7 && letter != "I") || (ascii_I1 && prevCheck[13] == 1)) begin
            rgb = 12'hF00;
            prevCheck[13] <= 1;
        end else if ((ascii_N2 && counter == 8 && letter == "N") || (ascii_N2 && prevCheck[14] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[14] <= 1;
            lettersRight[7] = 1;
        end else if ((ascii_N2 && counter == 8 && letter != "N") || (ascii_N2 && prevCheck[15] == 1)) begin
            rgb = 12'hF00;
            prevCheck[15] <= 1;
        end else if ((ascii_E2 && counter == 9 && letter == "E") || (ascii_E2 && prevCheck[16] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[16] <= 1;
            lettersRight[8] = 1;
        end else if ((ascii_E2 && counter == 9 && letter != "E") || (ascii_E2 && prevCheck[17] == 1)) begin
            rgb = 12'hF00;
            prevCheck[17] <= 1; 
        end else if ((ascii_E3 && counter == 10 && letter == "E") || (ascii_E3 && prevCheck[18] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[18] <= 1;
            lettersRight[9] = 1;
        end else if ((ascii_E3 && counter == 10 && letter != "E") || (ascii_E3 && prevCheck[19] == 1)) begin
            rgb = 12'hF00;
            prevCheck[19] <= 1;
        end else if ((ascii_R && counter == 11 && letter == "R") || (ascii_R && prevCheck[20] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[20] <= 1;
            lettersRight[10] = 1;
        end else if ((ascii_R && counter == 11 && letter != "R") || (ascii_R && prevCheck[21] == 1)) begin
            rgb = 12'hF00;
            prevCheck[21] <= 1;
        end else if ((ascii_I2 && counter == 12 && letter == "I") || (ascii_I2 && prevCheck[22] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[22] <= 1;
            lettersRight[11] = 1;
        end else if ((ascii_I2 && counter == 12 && letter != "I") || (ascii_I2 && prevCheck[23] == 1)) begin
            rgb = 12'hF00;
            prevCheck[23] <= 1;
        end else if ((ascii_N3 && counter == 13 && letter == "N") || (ascii_N3 && prevCheck[24] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[24] <= 1;
            lettersRight[12] = 1;
        end else if ((ascii_N3 && counter == 13 && letter != "N") || (ascii_N3 && prevCheck[25] == 1)) begin
            rgb = 12'hF00;
            prevCheck[25] <= 1;
        end else if ((ascii_G2 && counter == 14 && letter == "G") || (ascii_G2 && prevCheck[26] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[26] <= 1;
            lettersRight[13] = 1;
        end else if ((ascii_G2 && counter == 14 && letter != "G") || (ascii_G2 && prevCheck[27] == 1)) begin
            rgb = 12'hF00;
            prevCheck[27] <= 1;
        end else
            rgb = 12'hFFF; // White background
    end
endmodule
