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
    input clk, reset, dot, dash,
    output reg [8:0] morseLetter
    );
    
    // defining all the possible FSM state
    localparam IDLE = 2'b00, BUILDING = 2'b01;
    
    reg [4:0] timeSinceLastPress;
    // build the word before outputing
    reg [5:0] tempLetter;
    // total number of clk cycles
    reg [99:0] clkCounter;
    // keep track of length of the word for metadata
    reg [2:0] wordLen;
    reg [1:0] currState, nextState;
    
    wire newClk;
    assign newClk = clk;
    //clk_divider c(clk, reset, newClk);
    
    // call debouncer for buttons
    wire cleanDot, cleanDash;
    debouncer deb(clk, dot, cleanDot);
    debouncer deb2(clk, dash, cleanDash);
    
    initial begin
        currState = IDLE;
        nextState = IDLE;
        wordLen = 3'b0;
        clkCounter = 100'b0;
        timeSinceLastPress = 5'b0;
        tempLetter = 6'b0;
        morseLetter = 9'b0;
    end
    
    always @(posedge newClk or posedge reset) begin
        if (reset) begin
            currState = IDLE;
            wordLen = 3'b0;
            clkCounter = 100'b0;
            timeSinceLastPress = 5'b0;
            tempLetter = 6'b0;
        end
        else
            currState <= nextState;
    end
    
    always @(posedge newClk) begin
        timeSinceLastPress <= timeSinceLastPress + 1;
        clkCounter <= clkCounter + 1;
        
        if (timeSinceLastPress > 10 || (wordLen == 3'b0 && clkCounter > 20)) begin
            morseLetter = {wordLen, tempLetter};
            nextState <= IDLE;
        end
    end
    
    
    always @(posedge newClk) begin
        case(currState)
            IDLE: begin
                wordLen = 3'b0;
                tempLetter = 6'b0;
                clkCounter = 100'b0;
                timeSinceLastPress = 5'b0;
                if(cleanDot) begin
                    tempLetter = tempLetter << 1; // bit shift with 0 to represent dot
                    wordLen = 3'b001;
                    nextState <= BUILDING;
                    timeSinceLastPress <= 0; // record a press
                end
                else if (cleanDash) begin
                    tempLetter[0] <= 1; // set to one and bitshift to represent dash
                    tempLetter = tempLetter << 1;
                    wordLen = 3'b001;
                    nextState <= BUILDING;
                    timeSinceLastPress <= 0;
                end
                else
                    nextState <= IDLE;
                
            end
            BUILDING: begin
                if(cleanDot) begin
                    tempLetter = tempLetter << 1;
                    wordLen <= wordLen + 1;
                    timeSinceLastPress <= 0;
                end
                else if (cleanDash) begin
                    tempLetter[0] <= 1;
                    wordLen <= wordLen + 1;
                    timeSinceLastPress <= 0;
                    tempLetter = tempLetter << 1;
                end
                
                nextState <= BUILDING;
                
            end
        endcase
    end
    
endmodule
