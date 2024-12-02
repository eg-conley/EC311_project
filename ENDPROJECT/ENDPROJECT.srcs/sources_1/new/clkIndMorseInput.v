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
                    morseLetter = {wordLen, tempLetter};
                    nextState <= IDLE;
                end
                else begin
                    nextState <= BUILDING;
                end
            end
        endcase
    end
    
    
endmodule
