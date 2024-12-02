`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 09:50:51 AM
// Design Name: 
// Module Name: clkIndMorseInput
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

// this module is morse input but with a button to say when you are done with a letter
// going to make clk easier
module clkIndMorseInput(
    input clk, reset, dot, dash, done,
    output reg [8:0] morseLetter
    );
    // defining all the possible FSM state
    localparam IDLE = 2'b00, BUILDING = 2'b01;
    
    reg [5:0] tempLetter;
   
    // keep track of length of the word for metadata
    reg [2:0] wordLen;
    reg [1:0] currState, nextState;
    
    // call debouncer for buttons
    wire cleanDot, cleanDash, cleanDone;
    debouncer deb(clk, dot, cleanDot);
    debouncer deb2(clk, dash, cleanDash);
    debouncer deb3(clk, done, cleanDone);
    
    
    initial begin
        currState = IDLE;
        nextState = IDLE;
        wordLen = 3'b0;
        tempLetter = 6'b0;
        morseLetter = 9'b0;
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            currState = IDLE;
            wordLen = 3'b0;
            tempLetter = 6'b0;
        end
        else
            currState <= nextState;
    end
    
    always @(posedge cleanDot or posedge cleanDash or posedge cleanDone) begin
        case(currState)
            IDLE: begin
                wordLen = 3'b0;
                tempLetter = 6'b0;
                if(cleanDot) begin
                    tempLetter = tempLetter << 1; // bit shift with 0 to represent dot
                    wordLen = 3'b001;
                    nextState <= BUILDING;
                end
                else if (cleanDash) begin
                    tempLetter[0] <= 1; // set to one and bitshift to represent dash
                    tempLetter = tempLetter << 1;
                    wordLen = 3'b001;
                    nextState <= BUILDING;
                end
                else if (cleanDone) begin // done with the letter (space)
                    morseLetter = 9'b111111111;
                    nextState <= IDLE;
                end
                
                
            end
            BUILDING: begin
                if(cleanDot) begin
                    tempLetter = tempLetter << 1;
                    wordLen <= wordLen + 1;
                    nextState <= BUILDING;
                end
                else if (cleanDash) begin
                    tempLetter[0] <= 1;
                    wordLen <= wordLen + 1;
                    tempLetter = tempLetter << 1;
                    nextState <= BUILDING;
                end
                else if (cleanDone) begin // done with the letter
                    case({wordLen, tempLetter})
                        9'b111111111: morseLetter = " "; // ASCII 32
                        9'b010000001: morseLetter = "a"; // ASCII 97
                        9'b100001000: morseLetter = "b"; // ASCII 98
                        9'b100001010: morseLetter = "c"; // ASCII 99
                        9'b011000100: morseLetter = "d"; // ASCII 100
                        9'b001000000: morseLetter = "e"; // ASCII 101
                        9'b100000010: morseLetter = "f"; // ASCII 102
                        9'b011000110: morseLetter = "g"; // ASCII 103
                        9'b100000000: morseLetter = "h"; // ASCII 104
                        9'b010000000: morseLetter = "i"; // ASCII 105
                        9'b100000111: morseLetter = "j"; // ASCII 106
                        9'b011000101: morseLetter = "k"; // ASCII 107
                        9'b100000100: morseLetter = "l"; // ASCII 108
                        9'b010000011: morseLetter = "m"; // ASCII 109
                        9'b010000010: morseLetter = "n"; // ASCII 110
                        9'b011000111: morseLetter = "o"; // ASCII 111
                        9'b100000110: morseLetter = "p"; // ASCII 112
                        9'b100001101: morseLetter = "q"; // ASCII 113
                        9'b011000010: morseLetter = "r"; // ASCII 114
                        9'b011000000: morseLetter = "s"; // ASCII 115
                        9'b001000001: morseLetter = "t"; // ASCII 116
                        9'b011000001: morseLetter = "u"; // ASCII 117
                        9'b100000001: morseLetter = "v"; // ASCII 118
                        9'b011000011: morseLetter = "w"; // ASCII 119
                        9'b100001001: morseLetter = "x"; // ASCII 120
                        9'b100001011: morseLetter = "y"; // ASCII 121
                        9'b100001100: morseLetter = "z"; // ASCII 122
                        9'b101001111: morseLetter = "1"; // ASCII 49
                        9'b101000111: morseLetter = "2"; // ASCII 50
                        9'b101000011: morseLetter = "3"; // ASCII 51
                        9'b101000001: morseLetter = "4"; // ASCII 52
                        9'b101000000: morseLetter = "5"; // ASCII 53
                        9'b101010000: morseLetter = "6"; // ASCII 54
                        9'b101011000: morseLetter = "7"; // ASCII 55
                        9'b101011100: morseLetter = "8"; // ASCII 56
                        9'b101011110: morseLetter = "9"; // ASCII 57
                        9'b101011111: morseLetter = "0"; // ASCII 48
                        default: morseLetter = " ";
                    endcase 
                    nextState <= IDLE;
                end
                else begin
                    nextState <= BUILDING;
                end
            end
        endcase
    end
    
    
endmodule
