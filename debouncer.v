`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 03:59:18 PM
// Design Name: 
// Module Name: newDebouncer
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


module debouncer(
    input wire clk,           // Clock input
    input wire rst,           // Reset input
    input wire btn,           // Input button (e.g., btn_dot, btn_dash, btn_enter)
    output reg btn_stable,     // Debounced stable button output
    output reg btn_stable_posedge
);
    // Internal counter and register for debouncing logic
    reg [15:0] counter;       // Counter to wait for the button to stabilize
    reg btn_state;
    
    initial begin
        counter = 0;
        btn_stable =0;
        btn_stable_posedge= 0;
        btn_state = 0;
    end
    
    // Parameters for the debounce timing (assuming a 50 MHz clock)
    parameter DEBOUNCE_TIME = 50000;  // Adjust this value for your clock frequency

    
    always @(posedge clk) begin
        if (btn == btn_stable) begin
//            btn_stable <= 0;
            counter = 0;
            btn_stable_posedge = 0;

        end else begin
            if (counter >= DEBOUNCE_TIME) begin
                btn_stable = btn;
                counter = 0;
                
                if((btn_state==0) && (btn==1)) begin
                    btn_stable_posedge = 1;
                end
            end else begin
                counter = counter + 1;
                btn_stable_posedge = 0;
            end
        end
        
        btn_state = btn_stable;
        
        end
        
endmodule
