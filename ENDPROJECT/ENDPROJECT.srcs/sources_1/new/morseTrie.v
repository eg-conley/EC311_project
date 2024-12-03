`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 08:58:47 PM
// Design Name: 
// Module Name: morseTrie
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

module morseTrie(
    input clk, reset, dot, dash, done,
    output reg [7:0] morseLetter, currLetter
    );

    //reg [7:0] currLetter;
    reg [7:0] nextLetter;
   
    // keep track of length of the word for metadata
    reg [2:0] wordLen;
    
    // call debouncer for buttons
    wire cleanDot, cleanDash, cleanDone;
    debouncer deb(clk, dot, cleanDot);
    debouncer deb2(clk, dash, cleanDash);
    debouncer deb3(clk, done, cleanDone);
    
    //wire newClk;
    //clk_divider div(clk, reset, newClk);
    
    initial begin
        wordLen <= 3'b0;
        currLetter <= " ";
        nextLetter <= " ";
        morseLetter <= 8'b0;
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wordLen <= 3'b0;
            currLetter <= " ";
            nextLetter <= " ";
            morseLetter <= 8'b0;
        end
        else
            currLetter <= nextLetter;
    end
    
    always @(posedge cleanDot or posedge cleanDash or posedge cleanDone) begin
        if(cleanDone) begin
            morseLetter <= currLetter;
            currLetter <= " ";
            nextLetter <= " ";
        end
        else begin
            case(currLetter)
                " ": begin
                    if(cleanDot) begin
                        nextLetter <= "E";
                    end
                    else if(cleanDash) begin
                        nextLetter <= "T";
                    end
                end
                "E": begin
                    if(cleanDot) begin
                        nextLetter <= "I";
                    end
                    else if(cleanDash) begin
                        nextLetter <= "A";
                    end
                end
                "I": begin
                    if(cleanDot) begin
                        nextLetter <= "S";
                    end
                    else if(cleanDash) begin
                        nextLetter <= "U";
                    end
                end
                "S": begin
                    if(cleanDot) begin
                        nextLetter <= "H";
                    end
                    else if(cleanDash) begin
                        nextLetter <= "V";
                    end
                end
                "U": begin
                    if(cleanDot) begin
                        nextLetter <= "F";
                    end
                end
                "A": begin
                    if(cleanDot) begin
                        nextLetter <= "R";
                    end
                    else if(cleanDash) begin
                        nextLetter <= "W";
                    end
                end
                "R": begin
                    if(cleanDot) begin
                        nextLetter <= "L";
                    end
                end
                "W": begin
                    if(cleanDot) begin
                        nextLetter <= "P";
                    end
                    else if(cleanDash) begin
                        nextLetter <= "J";
                    end
                end
                "T": begin
                    if(cleanDot) begin
                        nextLetter <= "N";
                    end
                    else if(cleanDash) begin
                        nextLetter <= "M";
                    end
                end
                "N": begin
                    if(cleanDot) begin
                        nextLetter <= "D";
                    end
                    else if(cleanDash) begin
                        nextLetter <= "K";
                    end
                end
                "D": begin
                    if(cleanDot) begin
                        nextLetter <= "B";
                    end
                    else if(cleanDash) begin
                        nextLetter <= "X";
                    end
                end
                "K": begin
                    if(cleanDot) begin
                        nextLetter <= "C";
                    end
                    else if(cleanDash) begin
                        nextLetter <= "Y";
                    end
                end
                "M": begin
                    if(cleanDot) begin
                        nextLetter <= "G";
                    end
                    else if(cleanDash) begin
                        nextLetter <= "O";
                    end
                end
                "G": begin
                    if(cleanDot) begin
                        nextLetter <= "Z";
                    end
                    else if(cleanDash) begin
                        nextLetter <= "Q";
                    end
                end
                default: begin
                    nextLetter <= currLetter;
                end
            endcase
        end
    end
endmodule
