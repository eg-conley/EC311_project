`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2024 08:08:00 PM
// Design Name: 
// Module Name: morseInput
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

// the goal of this module is to recieve the button inputs and ouput the morse code
module morseInput(
    input dot, dash, clk, reset,
    output reg [8:0] morseLetter
    );
    
    // defining all the possible FSM state
    localparam IDLE = 2'b00, BUILDING = 2'b01, DONE = 2'b10;
    
    reg [4:0] timeSinceLastPress;
    // build the word before outputing
    reg [5:0] tempLetter;
    reg [5:0] clkCounter;
    reg [2:0] wordLen;

    reg [1:0] currState, nextState;
    
    //TODO: NEED TO CALL DEBOUNCER FOR THE BUTTONS
    wire cleanDot, cleanDash;
    
    initial begin
        currState = IDLE;
        nextState = IDLE;
        wordLen = 3'b0;
        clkCounter = 6'b0;
        timeSinceLastPress = 5'b0;
        tempLetter = 6'b0;
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            currState <= IDLE;
            wordLen = 3'b0;
            clkCounter = 6'b0;
            timeSinceLastPress = 5'b0;
            tempLetter = 6'b0;
        end
        else 
            currState <= nextState;
    end
    
    always @(posedge clk) begin
        case(currState)
            IDLE: begin
                if(cleanDot) begin
                    //bit shift left
                    wordLen <= wordLen + 1;
                    nextState <= BUILDING;
                end
                else if (cleanDash) begin
                    tempLetter[0] <= 1;
                    // bit shift left
                    wordLen <= wordLen + 1;
                    nextState <= BUILDING;
                end
                
                clkCounter <= clkCounter + 1;
            end
            BUILDING: begin
                if(cleanDot) begin
                    //bit shift left
                    wordLen <= wordLen + 1;
                    timeSinceLastPress <= 0;
                end
                else if (cleanDash) begin
                    tempLetter[0] = 1;
                    // bit shift left
                    wordLen <= wordLen + 1;
                    timeSinceLastPress <= 0;
                end
                else if (~cleanDash && ~cleanDot) begin
                    timeSinceLastPress <= timeSinceLastPress + 1;
                end
                
                // check if we are at the end of the letter or we are at the end of the word
                if (timeSinceLastPress > 3 || (wordLen == 3'b0 && clkCounter > 7)) begin
                    nextState <= DONE;
                end else begin
                    nextState <= BUILDING;
                end
                
                clkCounter = clkCounter + 1;
            end
            DONE: begin
                // bit shift right
                morseLetter = {wordLen, tempLetter};
            end
        endcase
    end
    
    
    
    
    
    
    
       
    
endmodule
