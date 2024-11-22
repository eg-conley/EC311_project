`timescale 1ns / 1ps

module vga_controller(clk, letterIn, h_sync, v_sync, led_on, letterToScreen);
    
    input clk, letterIn;
    output reg h_sync, v_sync, led_on, letterToScreen;
    
    localparam TOTAL_WIDTH = 800;
    localparam TOTAL_HEIGHT = 525;
    localparam ACTIVE_WIDTH = 640;
    localparam ACTIVE_HEIGHT = 480;
    localparam H_SYNC_COLUMN = 704;
    localparam V_SYNC_LINE = 523;
    
    reg [11:0] widthPos = 0;
    reg [11:0] heightPos = 0;
    
    
    wire enable = ((widthPos >=50 & widthPos < 690) & (heightPos >=33 & heightPos < 513)) ? 1'b1: 1'b0; // background
    
    // Following always block ensures that 
    // you go through all pixel coordinates
    always@(posedge clk)
    begin
        // check if end of the width 
        if(widthPos < TOTAL_WIDTH -1)
        begin 
            widthPos <= widthPos + 1;
        end
        else
        begin
            // move back to the first column
            widthPos <=0;
            // check if end of the height
            if(heightPos < TOTAL_HEIGHT -1)
            begin
                heightPos <= heightPos + 1;
            end
            else
            begin
                 heightPos <= 0;
            end       
        end
    end
    
    // generate horizontal sync
    always@(posedge clk)
    begin
        if (widthPos < H_SYNC_COLUMN)
        begin
            h_sync <= 1'b1;
        end
        else
        begin
            h_sync <= 1'b0;
        end
   end

    // generates vertical sync
    always@(posedge clk)
    begin
        if (heightPos < V_SYNC_LINE)
        begin
            v_sync <= 1'b1;
        end
        else
        begin
            v_sync <= 1'b0;
        end
   end
    
    // define all letters here:
    
    localparam I_X = 300;  // Starting X position (adjust to center)
    localparam I_Y = 200;  // Starting Y position (adjust to center)
    localparam I_Width = 10;  // Width of "I"
    localparam I_Height = 40; // Height of "I"
    
    localparam T_X = 300;  // Starting X position (adjust to center)
    localparam T_Y = 150;  // Starting Y position (adjust to center)
    localparam T_Width = 5;  // Width of "T"
    localparam T_Height = 7; // Height of "T"
    
    // main logic
    always @(posedge clk) begin
        if (enable) begin
            case(letterIn)
                "I": begin // turn on the pixels in I
                    if (widthPos >= I_X && widthPos < (I_X + I_Width) && heightPos >= I_Y && heightPos < (I_Y + I_Height))
                        led_on <= 1'b1; // turn on pixels in I
                     else
                        led_on <= 1'b0;
                 end
                 "T": begin
                    if (widthPos >= T_X && widthPos < (T_X + T_Width) && heightPos >= T_Y && heightPos < (T_Y + T_Height) &&
                    (heightPos - T_Y == 0) || (widthPos - T_X == 2) && (heightPos - T_Y >= 1 && heightPos - T_Y < T_Height) )
                        led_on <= 1'b1; // turn on pixels in T
                    else
                        led_on <=1'b0; // turn off pixels outside of T
                  end
               endcase // of of case statement
            end // end of if enabled
         else // if enable is not true
            led_on <= 1'b0; // no display at all
   end
endmodule




    
/*// this is you main logic based on 
    // your project
    always@(posedge clk)
    begin
        if(enable)
        begin
            led_on <= 1'b1;
        end
        else
        begin
            led_on <= 1'b0;
        end 
   end 
endmodule */
