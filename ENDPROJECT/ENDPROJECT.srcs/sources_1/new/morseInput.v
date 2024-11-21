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
    debouncer deb(clk, dot, cleanDot);
    debouncer deb2(clk, dash, cleanDash);
    
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
            clkCounter = clkCounter + 1;
    end
    
    
    always @(posedge cleanDot or posedge cleanDash) begin
        case(currState)
            IDLE: begin
                if(cleanDot) begin
                    tempLetter <= tempLetter << 1;
                    wordLen <= wordLen + 1;
                    nextState <= BUILDING;
                end
                else if (cleanDash) begin
                    tempLetter[0] <= 1;
                    tempLetter <= tempLetter << 1;
                    wordLen <= wordLen + 1;
                    nextState <= BUILDING;
                end
                
                
            end
            BUILDING: begin
                if(cleanDot) begin
                    tempLetter <= tempLetter << 1;
                    wordLen <= wordLen + 1;
                    timeSinceLastPress <= 0;
                end
                else if (cleanDash) begin
                    tempLetter[0] = 1;
                    tempLetter <= tempLetter << 1;
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
                
            end
            DONE: begin
                tempLetter <= tempLetter >> 1;
                morseLetter = {wordLen, tempLetter};
                wordLen = 3'b0;
                clkCounter = 6'b0;
                timeSinceLastPress = 5'b0;
                tempLetter = 6'b0;
                nextState <= IDLE;
            end
        endcase
    end
    
    
    
    
    
    
    
       
    
endmodule
