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
    output reg [7:0] morseLetter
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
    
    // call debouncer for buttons
    wire cleanDot, cleanDash;
    deb DEB1(clk, dot, cleanDot);
    deb DEB2(clk, dash, cleanDash);
    
    // initialize everything to 0
    initial begin
        currState = IDLE;
        nextState = IDLE;
        wordLen = 3'b0;
        clkCounter = 100'b0;
        timeSinceLastPress = 5'b0;
        tempLetter = 6'b0;
        morseLetter = 9'b0;
    end
    
    // state transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            currState = IDLE;
            wordLen = 3'b0;
            clkCounter = 100'b0;
            timeSinceLastPress = 5'b0;
            tempLetter = 6'b0;
            morseLetter = 9'b0;
        end
        else
            currState <= nextState;
    end
    
    // fsm transition logic
    always @(posedge clk) begin
        timeSinceLastPress <= timeSinceLastPress + 1;
        clkCounter <= clkCounter + 1;
        
        //  go to idle state
        if (timeSinceLastPress > 10 || (wordLen == 3'b0 && clkCounter > 7)) begin
            // mapping input to ascii character
            case({wordLen, tempLetter})
                9'b000000000: morseLetter = " "; // ASCII 32
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
    end
  
    // if either button pushed, build sequence and decide outputs
    always @ (posedge clk or posedge cleanDot or posedge cleanDash) begin
        if ( cleanDot ||  cleanDash) begin
    
        case(currState)
            IDLE: begin
                wordLen = 3'b0;
                tempLetter = 6'b0;
                clkCounter = 100'b0;
                timeSinceLastPress = 5'b0;
                if(dot) begin
                    tempLetter = tempLetter << 1; // bit shift with 0 to represent dot
                    wordLen = 3'b001;
                    nextState <= BUILDING;
                    timeSinceLastPress <= 0; // record a press
                end
                else if (dash) begin
                    tempLetter[0] <= 1; // set to one and bitshift to represent dash
                    tempLetter = tempLetter << 1;
                    wordLen = 3'b001;
                    nextState <= BUILDING;
                    timeSinceLastPress <= 0;
                end
            end
           
            BUILDING: begin
                if(cleanDot) begin
                    tempLetter = tempLetter << 1;
                    wordLen <= wordLen + 1;
                    timeSinceLastPress <= 0;
                    nextState <= BUILDING; 
                end
                else if (cleanDash) begin
                    tempLetter[0] <= 1;
                    wordLen <= wordLen + 1;
                    timeSinceLastPress <= 0;
                    tempLetter = tempLetter << 1;
                    nextState <= BUILDING; 
                end
            end
            
        endcase
      end // for if statement
    end
    
endmodule
