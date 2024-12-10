`timescale 1ns / 1ps
// created with references from https://github.com/FPGADude/Digital-Design/tree/main/FPGA%20Projects/VGA%20Projects/VGA%20Text%20Generation

module level_3_display(
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
    wire ascii_bit_on1, ascii_bit_on2; // display bit or not

    // instantiate ASCII ROM
    ascii_rom rom(clk, rom_addr, rom_data);
      
    // assign the address to ROM (ASCII value + row)
    assign rom_addr = {ascii_char, char_row};
    assign ascii_bit = rom_data[~bit_addr]; // reverse bit order for the character
    
    // level setup
    assign ascii_char = 
    // "LEVEL 3" at y = 152 to 168
    ((x >= 296 && x < 304) && (y >= 152 && y < 168)) ? 7'h4c : 
    ((x >= 304 && x < 312) && (y >= 152 && y < 168)) ? 7'h45 : 
    ((x >= 312 && x < 320) && (y >= 152 && y < 168)) ? 7'h56 : 
    ((x >= 320 && x < 328) && (y >= 152 && y < 168)) ? 7'h45 : 
    ((x >= 328 && x < 336) && (y >= 152 && y < 168)) ? 7'h4c : 
    ((x >= 336 && x < 344) && (y >= 152 && y < 168)) ? 7'h20 : 
    ((x >= 344 && x < 352) && (y >= 152 && y < 168)) ? 7'h33 : 
    
    // "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG" centered on screen width 640 at y = 216 to 232
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
    
    // USER INPUT LINE
    // "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG" centered on screen width 640 at y = 200 to 216
    ((x >= 144 && x < 152) && (y >= 232 && y < 248)) ? 7'h54 : // T
    ((x >= 152 && x < 160) && (y >= 232 && y < 248)) ? 7'h48 : // H
    ((x >= 160 && x < 168) && (y >= 232 && y < 248)) ? 7'h45 : // E
    ((x >= 168 && x < 176) && (y >= 232 && y < 248)) ? 7'h20 : // Space
    ((x >= 176 && x < 184) && (y >= 232 && y < 248)) ? 7'h51 : // Q
    ((x >= 184 && x < 192) && (y >= 232 && y < 248)) ? 7'h55 : // U
    ((x >= 192 && x < 200) && (y >= 232 && y < 248)) ? 7'h49 : // I
    ((x >= 200 && x < 208) && (y >= 232 && y < 248)) ? 7'h43 : // C
    ((x >= 208 && x < 216) && (y >= 232 && y < 248)) ? 7'h4B : // K
    ((x >= 216 && x < 224) && (y >= 232 && y < 248)) ? 7'h20 : // Space
    ((x >= 224 && x < 232) && (y >= 232 && y < 248)) ? 7'h42 : // B
    ((x >= 232 && x < 240) && (y >= 232 && y < 248)) ? 7'h52 : // R
    ((x >= 240 && x < 248) && (y >= 232 && y < 248)) ? 7'h4F : // O
    ((x >= 248 && x < 256) && (y >= 232 && y < 248)) ? 7'h57 : // W
    ((x >= 256 && x < 264) && (y >= 232 && y < 248)) ? 7'h4E : // N
    ((x >= 264 && x < 272) && (y >= 232 && y < 248)) ? 7'h20 : // Space
    ((x >= 272 && x < 280) && (y >= 232 && y < 248)) ? 7'h46 : // F
    ((x >= 280 && x < 288) && (y >= 232 && y < 248)) ? 7'h4F : // O
    ((x >= 288 && x < 296) && (y >= 232 && y < 248)) ? 7'h58 : // X
    ((x >= 296 && x < 304) && (y >= 232 && y < 248)) ? 7'h20 : // Space
    ((x >= 304 && x < 312) && (y >= 232 && y < 248)) ? 7'h4A : // J
    ((x >= 312 && x < 320) && (y >= 232 && y < 248)) ? 7'h55 : // U
    ((x >= 320 && x < 328) && (y >= 232 && y < 248)) ? 7'h4D : // M
    ((x >= 328 && x < 336) && (y >= 232 && y < 248)) ? 7'h50 : // P
    ((x >= 336 && x < 344) && (y >= 232 && y < 248)) ? 7'h53 : // S
    ((x >= 344 && x < 352) && (y >= 232 && y < 248)) ? 7'h20 : // Space
    ((x >= 352 && x < 360) && (y >= 232 && y < 248)) ? 7'h4F : // O
    ((x >= 360 && x < 368) && (y >= 232 && y < 248)) ? 7'h56 : // V
    ((x >= 368 && x < 376) && (y >= 232 && y < 248)) ? 7'h45 : // E
    ((x >= 376 && x < 384) && (y >= 232 && y < 248)) ? 7'h52 : // R
    ((x >= 384 && x < 392) && (y >= 232 && y < 248)) ? 7'h20 : // Space
    ((x >= 392 && x < 400) && (y >= 232 && y < 248)) ? 7'h54 : // T
    ((x >= 400 && x < 408) && (y >= 232 && y < 248)) ? 7'h48 : // H
    ((x >= 408 && x < 416) && (y >= 232 && y < 248)) ? 7'h45 : // E
    ((x >= 416 && x < 424) && (y >= 232 && y < 248)) ? 7'h20 : // Space
    ((x >= 424 && x < 432) && (y >= 232 && y < 248)) ? 7'h4C : // L
    ((x >= 432 && x < 440) && (y >= 232 && y < 248)) ? 7'h41 : // A
    ((x >= 440 && x < 448) && (y >= 232 && y < 248)) ? 7'h5A : // Z
    ((x >= 448 && x < 456) && (y >= 232 && y < 248)) ? 7'h59 : // Y
    ((x >= 456 && x < 464) && (y >= 232 && y < 248)) ? 7'h20 : // Space
    ((x >= 464 && x < 472) && (y >= 232 && y < 248)) ? 7'h44 : // D
    ((x >= 472 && x < 480) && (y >= 232 && y < 248)) ? 7'h4F : // O
    ((x >= 480 && x < 488) && (y >= 232 && y < 248)) ? 7'h47 : // G
    7'h20; // deafult (blank space)

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
    wire ascii_A, ascii_B, ascii_C, ascii_D, ascii_E1, ascii_E2, ascii_E3, ascii_F, ascii_G, ascii_H1, ascii_H2, ascii_I, ascii_J, ascii_K, ascii_L, ascii_M;
    wire ascii_O1, ascii_O2, ascii_O3, ascii_O4 , ascii_P, ascii_Q, ascii_R, ascii_S, ascii_T1, ascii_T2, ascii_U1, ascii_U2;
    wire ascii_V, ascii_W, ascii_X, ascii_Y, ascii_Z, ascii_Space1, ascii_Space2, ascii_Space3, ascii_Space4, ascii_Space5, ascii_Space6, ascii_Space7, ascii_Space8;
    
    // initialize everything as 0 at start of level
    reg [90:0] prevCheck; // to keep track of letters to display
    reg [42:0] lettersRight; // to keep track of user input corresponding to expected
    initial begin
        prevCheck = 0;
        lettersRight = 0;
        lvl_won = 0; // false
    end   

    // assign constraints for letters
    assign ascii_bit_on1 = ((x >= 296 && x < 352) && (y >= 152 && y < 168)) ? ascii_bit : 1'b0;
    assign ascii_bit_on2 = ((x >= 144 && x < 488) && (y >= 216 && y < 232)) ? ascii_bit : 1'b0;
    assign ascii_T1 =  ((x >= 144 && x < 152) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_H1 = ((x >= 152 && x < 160) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_E1 = ((x >= 160 && x < 168) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_Space1 = ((x >= 168 && x < 176) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_Q = ((x >= 176 && x < 184) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_U1 = ((x >= 184 && x < 192) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_I = ((x >= 192 && x < 200) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_C = ((x >= 200 && x < 208) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_K = ((x >= 208 && x < 216) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_Space2 =((x >= 216 && x < 224) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
     
    assign ascii_B = ((x >= 224 && x < 232) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_R1 = ((x >= 232 && x < 240) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_O1 = ((x >= 240 && x < 248) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_W = ((x >= 248 && x < 256) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_N = ((x >= 256 && x < 264) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_Space3 = ((x >= 264 && x < 272) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_F = ((x >= 272 && x < 280) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_O2 = ((x >= 280 && x < 288) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_X = ((x >= 288 && x < 296) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_Space4 = ((x >= 296 && x < 304) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;

    assign ascii_J = ((x >= 304 && x < 312) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_U2 = ((x >= 312 && x < 320) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_M = ((x >= 320 && x < 328) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_P = ((x >= 328 && x < 336) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_S = ((x >= 336 && x < 344) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_Space5 = ((x >= 344 && x < 352) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_O3 = ((x >= 352 && x < 360) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_V = ((x >= 360 && x < 368) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_E2 = ((x >= 368 && x < 376) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_R2 = ((x >= 376 && x < 384) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_Space6 = ((x >= 384 && x < 392) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    
    assign ascii_T2 = ((x >= 392 && x < 400) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_H2 = ((x >= 400 && x < 408) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_E3 = ((x >= 408 && x < 416) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_Space7 =((x >= 416 && x < 424) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_L = ((x >= 424 && x < 432) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_A = ((x >= 432 && x < 440) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_Z = ((x >= 440 && x < 448) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_Y = ((x >= 448 && x < 456) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_Space8 = ((x >= 456 && x < 464) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_D = ((x >= 464 && x < 472) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_O4 = ((x >= 472 && x < 480) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    assign ascii_G = ((x >= 480 && x < 488) && (y >= 232 && y < 248)) ? ascii_bit : 1'b0;
    
    // RGB logic
    always @(posedge clk) begin
        if(counter == 44 && lettersRight == 43'b1111111111111111111111111111111111111111111)
            lvl_won <= 1;
            
        if(reset) begin
            prevCheck = 10'b0;
            lvl_won <= 0;
        end
        
        if (~video_on)
            rgb = 12'h000; // black
        else if (ascii_bit_on1 || ascii_bit_on2)
            rgb = 12'h000; // black
        else if((ascii_T1 && counter == 1 && letter == "T") || (ascii_T1 && prevCheck[0] == 1)) begin
            rgb = 12'h0F0; // green
            prevCheck[0] <= 1;
            lettersRight[0] = 1;
        end else if((ascii_T1 && counter == 1 && letter != "T") || (ascii_T1 && prevCheck[1] == 1)) begin
            rgb = 12'hF00; // red
            prevCheck[1] <= 1;
        end else if((ascii_H1 && counter == 2 && letter == "H") || (ascii_H1 && prevCheck[2] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[2] <= 1;
            lettersRight[1] = 1;
        end else if((ascii_H1 && counter == 2 && letter != "H") || (ascii_H1 && prevCheck[3] == 1)) begin
            rgb = 12'hF00;
            prevCheck[3] <= 1;
        end else if((ascii_E1 && counter == 3 && letter == "E") || (ascii_E1 && prevCheck[4] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[4] <= 1;
            lettersRight[2] = 1;
        end else if((ascii_E1 && counter == 3 && letter != "E") || (ascii_E1 && prevCheck[5] == 1)) begin
            rgb = 12'hF00;
            prevCheck[5] <= 1;
        end else if((ascii_Space1 && counter == 4 && letter == " ") || (ascii_Space1 && prevCheck[6] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[6] <= 1;
            lettersRight[3] = 1;
        end else if((ascii_Space1 && counter == 4 && letter != " ") || (ascii_Space1 && prevCheck[7] == 1)) begin
            rgb = 12'hF00;
            prevCheck[7] <= 1;
        end else if((ascii_Q && counter == 5 && letter == "Q") || (ascii_Q && prevCheck[8] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[8] <= 1;
            lettersRight[4] = 1;
        end else if((ascii_Q && counter == 5 && letter != "Q") || (ascii_Q && prevCheck[9] == 1)) begin
            rgb = 12'hF00;
            prevCheck[9] <= 1;
        end else if((ascii_U1 && counter == 6 && letter == "U") || (ascii_U1 && prevCheck[10] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[10] <= 1;
            lettersRight[5] = 1;
        end else if((ascii_U1 && counter == 6 && letter != "U") || (ascii_U1 && prevCheck[11] == 1)) begin
            rgb = 12'hF00;
            prevCheck[11] <= 1;
        end else if((ascii_I && counter == 7 && letter == "I") || (ascii_I && prevCheck[12] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[12] <= 1;
            lettersRight[6] = 1;
        end else if((ascii_I && counter == 7 && letter != "I") || (ascii_I && prevCheck[13] == 1)) begin
            rgb = 12'hF00;
            prevCheck[13] <= 1;
        end else if((ascii_C && counter == 8 && letter == "C") || (ascii_C && prevCheck[14] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[14] <= 1;
            lettersRight[7] = 1;
        end else if((ascii_C && counter == 8 && letter != "C") || (ascii_C && prevCheck[15] == 1)) begin
            rgb = 12'hF00;
            prevCheck[15] <= 1;
        end else if((ascii_K && counter == 9 && letter == "K") || (ascii_K && prevCheck[16] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[16] <= 1;
            lettersRight[8] = 1;
        end else if((ascii_K && counter == 9 && letter != "K") || (ascii_K && prevCheck[17] == 1)) begin
            rgb = 12'hF00;
            prevCheck[17] <= 1;
        end else if((ascii_Space2 && counter == 10 && letter == " ") || (ascii_Space2 && prevCheck[18] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[18] <= 1;
            lettersRight[9] = 1;
        end else if((ascii_Space2 && counter == 10 && letter != " ") || (ascii_Space2 && prevCheck[19] == 1)) begin
            rgb = 12'hF00;
            prevCheck[19] <= 1;
        end else if((ascii_B && counter == 11 && letter == "B") || (ascii_B && prevCheck[20] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[20] <= 1;
            lettersRight[10] = 1;
        end else if((ascii_B && counter == 11 && letter != "B") || (ascii_B && prevCheck[21] == 1)) begin
            rgb = 12'hF00;
            prevCheck[21] <= 1;
        end else if((ascii_R1 && counter == 12 && letter == "R") || (ascii_R1 && prevCheck[22] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[22] <= 1;
            lettersRight[11] = 1;
        end else if((ascii_R1 && counter == 12 && letter != "R") || (ascii_R1 && prevCheck[23] == 1)) begin
            rgb = 12'hF00;
            prevCheck[23] <= 1;
        end else if((ascii_O1 && counter == 13 && letter == "O") || (ascii_O1 && prevCheck[24] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[24] <= 1;
            lettersRight[12] = 1;
        end else if((ascii_O1 && counter == 13 && letter != "O") || (ascii_O1 && prevCheck[25] == 1)) begin
            rgb = 12'hF00;
            prevCheck[25] <= 1;
        end else if((ascii_W && counter == 14 && letter == "W") || (ascii_W && prevCheck[26] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[26] <= 1;
            lettersRight[13] = 1;
        end else if((ascii_W && counter == 14 && letter != "W") || (ascii_W && prevCheck[27] == 1)) begin
            rgb = 12'hF00;
            prevCheck[27] <= 1;
        end else if((ascii_N && counter == 15 && letter == "N") || (ascii_N && prevCheck[28] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[28] <= 1;
            lettersRight[14] = 1;
        end else if((ascii_N && counter == 15 && letter != "N") || (ascii_N && prevCheck[29] == 1)) begin
            rgb = 12'hF00;
            prevCheck[29] <= 1;
        end else if((ascii_Space3 && counter == 16 && letter == " ") || (ascii_Space3 && prevCheck[30] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[30] <= 1;
            lettersRight[15] = 1;
        end else if((ascii_Space3 && counter == 16 && letter != " ") || (ascii_Space3 && prevCheck[31] == 1)) begin
            rgb = 12'hF00;
            prevCheck[30] <= 1;
        end else if((ascii_F && counter == 17 && letter == "F") || (ascii_F && prevCheck[32] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[31] <= 1;
            lettersRight[16] = 1;
        end else if((ascii_F && counter == 17 && letter != "F") || (ascii_F && prevCheck[33] == 1)) begin
            rgb = 12'hF00;
            prevCheck[32] <= 1;
        end else if((ascii_O2 && counter == 18 && letter == "O") || (ascii_O2 && prevCheck[34] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[33] <= 1;
            lettersRight[17] = 1;
        end else if((ascii_O2 && counter == 18 && letter != "O") || (ascii_O2 && prevCheck[35] == 1)) begin
            rgb = 12'hF00;
            prevCheck[34] <= 1;
        end else if((ascii_X && counter == 19 && letter == "X") || (ascii_X && prevCheck[36] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[35] <= 1;
            lettersRight[18] = 1;
        end else if((ascii_X && counter == 19 && letter != "X") || (ascii_X && prevCheck[37] == 1)) begin
            rgb = 12'hF00;
            prevCheck[36] <= 1;
        end else if((ascii_Space4 && counter == 20 && letter == " ") || (ascii_Space4 && prevCheck[38] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[37] <= 1;
            lettersRight[19] = 1;
        end else if((ascii_Space4 && counter == 20 && letter != " ") || (ascii_Space4 && prevCheck[39] == 1)) begin
            rgb = 12'hF00;
            prevCheck[38] <= 1;
        end else if((ascii_J && counter == 21 && letter == "J") || (ascii_J && prevCheck[40] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[40] <= 1;
            lettersRight[20] = 1;
        end else if((ascii_J && counter == 21 && letter != "J") || (ascii_J && prevCheck[41] == 1)) begin
            rgb = 12'hF00;
            prevCheck[41] <= 1;
        end else if((ascii_U2 && counter == 22 && letter == "U") || (ascii_U2 && prevCheck[42] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[42] <= 1;
            lettersRight[21] = 1;
        end else if((ascii_U2 && counter == 22 && letter != "U") || (ascii_U2 && prevCheck[43] == 1)) begin
            rgb = 12'hF00;
            prevCheck[43] <= 1;
        end else if((ascii_M && counter == 23 && letter == "M") || (ascii_M && prevCheck[44] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[44] <= 1;
            lettersRight[22] = 1;
        end else if((ascii_M && counter == 23 && letter != "M") || (ascii_M && prevCheck[45] == 1)) begin
            rgb = 12'hF00;
            prevCheck[45] <= 1;
        end else if((ascii_P && counter == 24 && letter == "P") || (ascii_P && prevCheck[46] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[46] <= 1;
            lettersRight[23] = 1;
        end else if((ascii_P && counter == 24 && letter != "P") || (ascii_P && prevCheck[47] == 1)) begin
            rgb = 12'hF00;
            prevCheck[47] <= 1;
        end else if((ascii_S && counter == 25 && letter == "S") || (ascii_S && prevCheck[48] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[48] <= 1;
            lettersRight[24] = 1;
        end else if((ascii_S && counter == 25 && letter != "S") || (ascii_S && prevCheck[49] == 1)) begin
            rgb = 12'hF00;
            prevCheck[49] <= 1;
        end else if((ascii_Space5 && counter == 26 && letter == " ") || (ascii_Space5 && prevCheck[50] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[50] <= 1;
            lettersRight[25] = 1;
        end else if((ascii_Space5 && counter == 26 && letter != " ") || (ascii_Space5 && prevCheck[51] == 1)) begin
            rgb = 12'hF00;
            prevCheck[51] <= 1;
        end else if((ascii_O3 && counter == 27 && letter == "O") || (ascii_O3 && prevCheck[52] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[52] <= 1;
            lettersRight[26] = 1;
        end else if((ascii_O3 && counter == 27 && letter != "O") || (ascii_O3 && prevCheck[53] == 1)) begin
            rgb = 12'hF00;
            prevCheck[53] <= 1;
        end else if((ascii_V && counter == 28 && letter == "V") || (ascii_V && prevCheck[54] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[54] <= 1;
            lettersRight[27] = 1;
        end else if((ascii_V && counter == 28 && letter != "V") || (ascii_V && prevCheck[55] == 1)) begin
            rgb = 12'hF00;
            prevCheck[55] <= 1;
        end else if((ascii_E2 && counter == 29 && letter == "E") || (ascii_E2 && prevCheck[56] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[56] <= 1;
            lettersRight[28] = 1;
        end else if((ascii_E2 && counter == 29 && letter != "E") || (ascii_E2 && prevCheck[57] == 1)) begin
            rgb = 12'hF00;
            prevCheck[57] <= 1;
        end else if((ascii_R2 && counter == 30 && letter == "R") || (ascii_R2 && prevCheck[58] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[58] <= 1;
            lettersRight[29] = 1;
        end else if((ascii_R2 && counter == 30 && letter != "R") || (ascii_R2 && prevCheck[59] == 1)) begin
            rgb = 12'hF00;
            prevCheck[59] <= 1;
        end else if((ascii_Space6 && counter == 31 && letter == " ") || (ascii_Space6 && prevCheck[60] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[60] <= 1;
            lettersRight[30] = 1;
        end else if((ascii_Space6 && counter == 31 && letter != " ") || (ascii_Space6 && prevCheck[61] == 1)) begin
            rgb = 12'hF00;
            prevCheck[61] <= 1;
        end else if((ascii_T2 && counter == 32 && letter == "T") || (ascii_T2 && prevCheck[62] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[62] <= 1;
            lettersRight[31] = 1;
        end else if((ascii_T2 && counter == 32 && letter != "T") || (ascii_T2 && prevCheck[63] == 1)) begin
            rgb = 12'hF00;
            prevCheck[63] <= 1;
        end else if((ascii_H2 && counter == 33 && letter == "H") || (ascii_H2 && prevCheck[64] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[64] <= 1;
            lettersRight[32] = 1;
        end else if((ascii_H2 && counter == 33 && letter != "H") || (ascii_H2 && prevCheck[65] == 1)) begin
            rgb = 12'hF00;
            prevCheck[65] <= 1;
        end else if((ascii_E3 && counter == 34 && letter == "E") || (ascii_E3 && prevCheck[66] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[66] <= 1;
            lettersRight[33] = 1;
        end else if((ascii_E3 && counter == 34 && letter != "E") || (ascii_E3 && prevCheck[67] == 1)) begin
            rgb = 12'hF00;
            prevCheck[67] <= 1;
        end else if((ascii_Space7 && counter == 35 && letter == " ") || (ascii_Space7 && prevCheck[68] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[68] <= 1;
            lettersRight[34] = 1;
        end else if((ascii_Space7 && counter == 35 && letter != " ") || (ascii_Space7 && prevCheck[69] == 1)) begin
            rgb = 12'hF00;
            prevCheck[69] <= 1;
        end else if((ascii_L && counter == 36 && letter == "L") || (ascii_L && prevCheck[70] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[70] <= 1;
            lettersRight[35] = 1;
        end else if((ascii_L && counter == 36 && letter != "L") || (ascii_L && prevCheck[71] == 1)) begin
            rgb = 12'hF00;
            prevCheck[71] <= 1;
        end else if((ascii_A && counter == 37 && letter == "A") || (ascii_A && prevCheck[72] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[72] <= 1;
            lettersRight[36] = 1;
        end else if((ascii_A && counter == 37 && letter != "A") || (ascii_A && prevCheck[73] == 1)) begin
            rgb = 12'hF00;
            prevCheck[73] <= 1;
        end else if((ascii_Z && counter == 38 && letter == "Z") || (ascii_Z && prevCheck[74] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[74] <= 1;
            lettersRight[37] = 1;
        end else if((ascii_Z && counter == 38 && letter != "Z") || (ascii_Z && prevCheck[75] == 1)) begin
            rgb = 12'hF00;
            prevCheck[75] <= 1;
        end else if((ascii_Y && counter == 39 && letter == "Y") || (ascii_Y && prevCheck[76] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[76] <= 1;
            lettersRight[38] = 1;
        end else if((ascii_Y && counter == 39 && letter != "Y") || (ascii_Y && prevCheck[77] == 1)) begin
            rgb = 12'hF00;
            prevCheck[77] <= 1;
        end else if((ascii_Space8 && counter == 40 && letter == " ") || (ascii_Space8 && prevCheck[78] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[78] <= 1;
            lettersRight[39] = 1;
        end else if((ascii_Space8 && counter == 40 && letter != " ") || (ascii_Space8 && prevCheck[79] == 1)) begin
            rgb = 12'hF00;
            prevCheck[79] <= 1;
        end else if((ascii_D && counter == 41 && letter == "D") || (ascii_D && prevCheck[80] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[80] <= 1;
            lettersRight[40] = 1;
        end else if((ascii_D && counter == 41 && letter != "D") || (ascii_D && prevCheck[81] == 1)) begin
            rgb = 12'hF00;
            prevCheck[81] <= 1; 
        end else if((ascii_O4 && counter == 42 && letter == "O") || (ascii_O4 && prevCheck[82] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[82] <= 1;
            lettersRight[41] = 1;
        end else if((ascii_O4 && counter == 42 && letter != "O") || (ascii_O4 && prevCheck[83] == 1)) begin
            rgb = 12'hF00;
            prevCheck[83] <= 1;
        end else if((ascii_G && counter == 43 && letter == "G") || (ascii_G && prevCheck[84] == 1)) begin
            rgb = 12'h0F0;
            prevCheck[84] <= 1;
            lettersRight[42] = 1;
        end else if((ascii_G && counter == 43 && letter != "G") || (ascii_G && prevCheck[85] == 1)) begin
            rgb = 12'hF00;
            prevCheck[85] <= 1;
        end else
            rgb = 12'hFFF; // white
    end
    
endmodule
