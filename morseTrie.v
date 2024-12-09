`timescale 1ns / 1ps

module morseTrie(
    input clk, reset, dot, dash, done,
    output reg [7:0] morseLetter,
    output reg newLetter
    );

    reg [7:0] currLetter;
    
    // call debouncer for buttons
    wire cleanDot, cleanDash, cleanDone;
    wire posEdgeDot, posEdgeDash, posEdgeDone;
    
    debouncer DEB1(clk, reset, dot, cleanDot, posEdgeDot);
    debouncer DEB2(clk, reset, dash, cleanDash, posEdgeDash);
    debouncer DEB3(clk, reset, done, cleanDone, posEdgeDone);
    
    
    initial begin
        currLetter <= " ";
        morseLetter <= 8'b0;
    end
    
    always @(negedge clk or posedge reset) begin
        if(reset) begin
            currLetter <= " ";
            morseLetter <= 8'b0;
        end
        else if (posEdgeDone) begin
            morseLetter = currLetter;
            currLetter = " ";
            newLetter <= 1;
        end
        else if (posEdgeDash) begin
            case(currLetter)
                " ": currLetter <= "T";
                "E": currLetter <= "A";
                "I": currLetter <= "U";
                "S": currLetter <= "V";
                "U": currLetter <= "U";
                "A": currLetter <= "W";
                "R": currLetter <= "R";
                "W": currLetter <= "J";
                "T": currLetter <= "M";
                "N": currLetter <= "K";
                "D": currLetter <= "X";
                "K": currLetter <= "Y";
                "M": currLetter <= "O";
                "G": currLetter <= "Q";
            endcase
        end 
        else if( posEdgeDot) begin
            case(currLetter)
                " ": currLetter <= "E";
                "E": currLetter <= "I";
                "I": currLetter <= "S";
                "S": currLetter <= "H";
                "U": currLetter <= "F";
                "A": currLetter <= "R";
                "R": currLetter <= "L";
                "W": currLetter <= "P";
                "T": currLetter <= "N";
                "N": currLetter <= "D";
                "D": currLetter <= "B";
                "K": currLetter <= "C";
                "M": currLetter <= "G";
                "G": currLetter <= "Z";
            endcase
        end
        else begin
            newLetter <= 0;
        end
    end
endmodule
