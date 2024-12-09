`timescale 1ns / 1ps

module fsm_top(
    input clk, // 100 MHz
    input reset,
    input dot,
    input dash,
    input done,
    input practice,
    input lvl_1, 
    input lvl_2, 
    input lvl_3,
    output hsync,
    output vsync,
    output reg [11:0] rgb,
    output reg [7:0] counter
    );
    
    // instantiate morseTrie
    wire [7:0] letter;
    wire posLetterEdge;
    morseTrie MORSETRIE(clk, reset, dot, dash, done, letter, posLetterEdge);
    
    // instantiate vga controller
    wire [9:0] x;
    wire [9:0] y; // x and y coordinates on screen display
    wire video_on, tick; // ON if x and y are in display area 640 x 480
    vga_controller VGA_CONTROLLER(clk, reset, video_on, hsync, vsync, newClk, x, y);
    
    reg [11:0] curr_rgb, next_rgb;
    wire [11:0] rgb_start;
    wire [11:0] rgb_practice;
    wire [11:0] rgb_level_1;
    wire [11:0] rgb_level_2;
    wire [11:0] rgb_level_3;
    wire [11:0] rgb_done;
        
    // initialize vga modules
    wire lvl_1_won, lvl_2_won, lvl_3_won;
    start_page_display START_PAGE_DISPLAY(clk, video_on, x, y, rgb_start);
    practice_display PRACTICE_DISPLAY(clk, video_on, x, y, letter, rgb_practice);
    level_1_display LEVEL_1_DISPLAY(clk, reset, video_on, x, y, letter, counter, lvl_1_won, rgb_level_1);
    level_2_display LEVEL_2_DISPLAY(clk, reset, video_on, x, y, letter, counter, lvl_2_won, rgb_level_2);
    level_3_display LEVEL_3_DISPLAY(clk, reset, video_on, x, y, letter, counter, lvl_3_won, rgb_level_3);
    done_page_display DONE_PAGE_DISPLAY(clk, video_on, x, y, rgb_done);
   
    // FSM states
    localparam START_PAGE = 3'b000; // 0
    localparam PRACTICE_MODE = 3'b001; // 1
    localparam ESCAPE_LVL_1 = 3'b010; // 2
    localparam ESCAPE_LVL_2 = 3'b011; // 3
    localparam ESCAPE_LVL_3 = 3'b100; // 4
    localparam DONE = 3'b101; // 5
    reg [2:0] currState, nextState;
    
    // call debouncer for buttons
    debouncer DEB1(clk, reset, dot, cleanDot, posEdgeDot);
    debouncer DEB2(clk, reset, dash, cleanDash, posEdgeDash);
    debouncer DEB3(clk, reset, done, cleanDone, posEdgeDone);
    
    // initialize states and variables
    initial begin
        currState <= START_PAGE;
        curr_rgb <= rgb_start;
    end
        
    // state update logic
    always @(posedge clk) begin
        if(posLetterEdge) 
            counter <= counter + 1;
        if (reset) begin
            currState <= START_PAGE;
            nextState <= START_PAGE;
            curr_rgb <= rgb_start;
            counter <= 0;
        end
        else begin
            currState <= nextState;
            curr_rgb <= next_rgb;
        end
    end
      
     // state transition logic
    always @(*) begin
        if(practice) begin
            nextState <= PRACTICE_MODE;
            next_rgb <= rgb_practice;
        end else if(lvl_1) begin
            if (lvl_1_won) begin
                nextState <= DONE;
                next_rgb <= rgb_done;
            end
            else begin          
                nextState = ESCAPE_LVL_1;
                next_rgb <= rgb_level_1;
            end
        end else if(lvl_2) begin
            if (lvl_2_won) begin
                nextState <= DONE;
                next_rgb <= rgb_done;
            end
            else begin
                nextState = ESCAPE_LVL_2;
                next_rgb <= rgb_level_2;
            end
        end else if(lvl_3) begin
            if (lvl_3_won) begin
                nextState <= DONE;
                next_rgb <= rgb_done;
            end
            else begin
                nextState = ESCAPE_LVL_3;
                next_rgb <= rgb_level_3;
            end
        end
        else begin
            next_rgb <= rgb_start;
        end
    end
         
    // update screen
    always @(posedge newClk) begin
            rgb <= next_rgb;
   end 
            
endmodule
