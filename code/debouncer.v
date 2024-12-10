`timescale 1ns / 1ps

module debouncer(
    input wire clk,
    input wire rst,
    input wire btn, // button input button
    output reg btn_stable, // debounced stable output
    output reg btn_stable_posedge
    );
    
    // internal counter and register for debouncing logic
    reg [15:0] counter; // counter to wait for the button to stabilize
    reg btn_state;
    
    initial begin
        counter = 0;
        btn_stable = 0;
        btn_stable_posedge = 0;
        btn_state = 0;
    end
    
    // parameters for the debounce timing
    parameter DEBOUNCE_TIME = 50000;  // adjust this value for your clock frequency
    
    always @(posedge clk) begin
        if (btn == btn_stable) begin
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
