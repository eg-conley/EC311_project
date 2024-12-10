`timescale 1ns / 1ps

module fsm_top(
    input clk, // 100 MHz
    input reset, // button input
    input dot, // button input
    input dash, // button input
    input done, // button input
    input practice, // switch input
    input lvl_1, // switch input
    input lvl_2, // switch input
    input lvl_3, // switch input
    output hsync, // vga horizontal sync
    output vsync, // vga horizontal sync
    output reg [11:0] rgb // vga color
    );
    
    // instantiate morseTrie
    wire [7:0] letter;
    wire posLetterEdge; // to keep track of number of letters
    
    morseTrie MORSETRIE(clk, reset, dot, dash, done, letter, posLetterEdge);
    
    // instantiate vga controller
    wire [9:0] x, y; // x and y coordinates on screen display
    wire video_on, tick; // ON if x and y are in display area 640 x 480
    
    vga_controller VGA_CONTROLLER(clk, reset, video_on, hsync, vsync, newClk, x, y);
    
    // instantiate vga modules
    reg [11:0] curr_rgb, next_rgb; // rbg states
    wire [11:0] rgb_start, rgb_practice, rgb_level_1, rgb_level_2, rgb_level_3, rgb_done; // vga display pages
    reg [7:0] counter; // counter for number of letters
    wire lvl_1_won, lvl_2_won, lvl_3_won; // win flags
    
    start_page_display START_PAGE_DISPLAY(clk, video_on, x, y, rgb_start);
    practice_display PRACTICE_DISPLAY(clk, video_on, x, y, letter, rgb_practice);
    level_1_display LEVEL_1_DISPLAY(clk, reset, video_on, x, y, letter, counter, lvl_1_won, rgb_level_1);
    level_2_display LEVEL_2_DISPLAY(clk, reset, video_on, x, y, letter, counter, lvl_2_won, rgb_level_2);
    level_3_display LEVEL_3_DISPLAY(clk, reset, video_on, x, y, letter, counter, lvl_3_won, rgb_level_3);
    done_page_display DONE_PAGE_DISPLAY(clk, video_on, x, y, rgb_done);
   
    // FSM states
    reg [2:0] currState, nextState;
    localparam START_PAGE = 3'b000; // 0
    localparam PRACTICE_MODE = 3'b001; // 1
    localparam ESCAPE_LVL_1 = 3'b010; // 2
    localparam ESCAPE_LVL_2 = 3'b011; // 3
    localparam ESCAPE_LVL_3 = 3'b100; // 4
    localparam DONE = 3'b101; // 5
    
    initial begin // initialize as START state
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
        end else begin
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
            end else begin          
                nextState = ESCAPE_LVL_1;
                next_rgb <= rgb_level_1;
            end
        end else if(lvl_2) begin
            if (lvl_2_won) begin
                nextState <= DONE;
                next_rgb <= rgb_done;
            end else begin
                nextState = ESCAPE_LVL_2;
                next_rgb <= rgb_level_2;
            end
        end else if(lvl_3) begin
            if (lvl_3_won) begin
                nextState <= DONE;
                next_rgb <= rgb_done;
            end else begin
                nextState = ESCAPE_LVL_3;
                next_rgb <= rgb_level_3;
            end
        end else begin
            next_rgb <= rgb_start;
        end
    end
         
    // update vga display
    always @(posedge newClk) begin
        rgb <= next_rgb;
    end 
            
endmodule
