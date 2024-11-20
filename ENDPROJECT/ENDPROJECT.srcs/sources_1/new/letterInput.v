`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2024 09:15:40 PM
// Design Name: 
// Module Name: letterInput
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// this goal of this module is to convert the dot-dash input from the morseInput module to an ASCII value that corresponds to a letter
module letterInput(
  input dot,
  input dash,
  input clk,
  input reset,
  output reg [7:0] letter // 8 bits to represent ASCII value
  );
  
  wire [8:0] tempLetter; // 9 bits total, first 3 bits represent length of the letter, next 6 bits for dots and dashes (really need 5 but added extra for buffer
  morseInput MORSEINPUT(dot, dash, clk, reset, tempLetter);
  

  // dot = 0, dash = 1
  always @ (tempLetter) begin
    case(tempLetter)
        9'b000000000: letter = 8'b00100000; // space (ASCII 32)
        9'b010000001: letter = 8'b01100001; // a (ASCII 97)
        9'b100001000: letter = 8'b01100010; // b (ASCII 98)
        9'b100001010: letter = 8'b01100011; // c (ASCII 99)
        9'b011000100: letter = 8'b01100100; // d (ASCII 100)
        9'b001000000: letter = 8'b01100101; // e (ASCII 101)
        9'b100000010: letter = 8'b01100110; // f (ASCII 102)
        9'b011000110: letter = 8'b01100111; // g (ASCII 103)
        9'b100000000: letter = 8'b01101000; // h (ASCII 104)
        9'b010000000: letter = 8'b01101001; // i (ASCII 105)
        9'b100000111: letter = 8'b01101010; // j (ASCII 106)
        9'b011000101: letter = 8'b01101011; // k (ASCII 107)
        9'b100000100: letter = 8'b01101100; // l (ASCII 108)
        9'b010000011: letter = 8'b01101101; // m (ASCII 109)
        9'b010000010: letter = 8'b01101110; // n (ASCII 110)
        9'b011000111: letter = 8'b01101111; // o (ASCII 111)
        9'b100000110: letter = 8'b01110000; // p (ASCII 112)
        9'b100001101: letter = 8'b01110001; // q (ASCII 113)
        9'b011000010: letter = 8'b01110010; // r (ASCII 114)
        9'b011000000: letter = 8'b01110011; // s (ASCII 115)
        9'b001000001: letter = 8'b01110100; // t (ASCII 116)
        9'b011000001: letter = 8'b01110101; // u (ASCII 117)
        9'b100000001: letter = 8'b01110110; // v (ASCII 118)
        9'b011000011: letter = 8'b01110111; // w (ASCII 119)
        9'b100001001: letter = 8'b01111000; // x (ASCII 120)
        9'b100001011: letter = 8'b01111001; // y (ASCII 121)
        9'b100001100: letter = 8'b01111010; // z (ASCII 122)
        9'b101001111: letter = 8'b00110001; // 1 (ASCII 49)
        9'b101000111: letter = 8'b00110010; // 2 (ASCII 50)
        9'b101000011: letter = 8'b00110011; // 3 (ASCII 51)
        9'b101000001: letter = 8'b00110100; // 4 (ASCII 52)
        9'b101000000: letter = 8'b00110101; // 5 (ASCII 53)
        9'b101010000: letter = 8'b00110110; // 6 (ASCII 54)
        9'b101011000: letter = 8'b00110111; // 7 (ASCII 55)
        9'b101011100: letter = 8'b00111000; // 8 (ASCII 56)
        9'b101011110: letter = 8'b00111001; // 9 (ASCII 57)
        9'b101011111: letter = 8'b00110000; // 0 (ASCII 48)
  endcase
 end
endmodule
