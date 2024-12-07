`timescale 1ns / 1ps

module fsm_top(
    input clk, // 100 MHz
    input reset,
    input dot, // double as the practice mode input
    input dash, // double as the escape mode input
    input done,
    input lvl_1_done, lvl_2_done, lvl_3_done, // for testing purposes
    output reg [2:0] gameState, // for testing purposes
    output hsync,
    output vsync,
    output reg [11:0] rgb, // rgb color we want to display
    output reg [4:0] counter
    );
    
    wire [7:0] letter;
    wire posLetterEdge;
    morseTrie MORSETRIE(clk, reset, dot, dash, done, letter);
    
    wire [9:0] x;
    wire [9:0] y; // x and y coordinates on screen display
    wire video_on, tick; // ON if x and y are in display area 640 x 480
    
    vga_controller VGA_CONTROLLER(clk, reset, video_on, hsync, vsync, newClk, x, y);
    
    reg [11:0] curr_rgb, next_rgb;
    wire [11:0] rgb_start;
    wire [11:0] rgb_practice;
    wire [11:0] rgb_level1;
    wire [11:0] rgb_level2;
    wire [11:0] rgb_level3;
    wire [11:0] rgb_done;
    
    //reg [4:0] counter; // tells you the current letter being inputted
    
    // initialize vga modules
    start_page_display START_PAGE_DISPLAY(clk, video_on, x, y, rgb_start);
    practice_display PRACTICE_DISPLAY(clk, video_on, x, y, letter, rgb_practice);
    level_1_display LEVEL_1_DISPLAY(clk, video_on, x, y, letter, rgb_level1);
    level_2_display LEVEL_2_DISPLAY(clk, video_on, x, y, letter, rgb_level2);
    level_3_display LEVEL_3_DISPLAY(clk, video_on, x, y, letter, rgb_level3);
    done_page_display DONE_PAGE_DISPLAY(clk, video_on, x, y, rgb_done);
    
        
    // FSM states
    localparam START_PAGE = 3'b000; // 0
    localparam PRACTICE_MODE = 3'b001; // 1
    localparam ESCAPE_LVL_1 = 3'b010; // 2
    localparam ESCAPE_LVL_2 = 3'b011; // 3
    localparam ESCAPE_LVL_3 = 3'b100; // 4
    localparam DONE = 3'b101; // 5
    
    // intermediate variables
    reg [2:0] currState, nextState;
    //reg lvl_1_done, lvl_2_done, lvl_3_done;
    
    // call debouncer for buttons
    debouncer DEB1(clk, reset, dot, cleanDot, posEdgeDot);
    debouncer DEB2(clk, reset, dash, cleanDash, posEdgeDash);
    debouncer DEB3(clk, reset, done, cleanDone, posEdgeDone);
    
    
    
    // initialize states and variables
    initial begin
        currState <= START_PAGE;
//        lvl_1_done = 0;
//        lvl_2_done = 0;
//        lvl_3_done = 0;
    end
        
    // state update logic
    always @(posedge clk) begin
        if(posLetterEdge) 
            counter <= counter + 1;
        if (reset) begin
            currState <= START_PAGE;
            counter <= 5'b0;
//            lvl_1_done = 0;
//            lvl_2_done = 0;
//            lvl_3_done = 0;
        end
        else begin
            currState <= nextState;
            curr_rgb <= next_rgb;
        end
    end
      
     // state transition logic
    always @(*) begin
            case(currState)
                START_PAGE:
                    if (posEdgeDot) begin
                        nextState <= PRACTICE_MODE;
                        gameState <= PRACTICE_MODE;
                        next_rgb <= rgb_practice;
                        //letter <= " ";
                    end 
                    else if (posEdgeDash) begin
                        nextState = ESCAPE_LVL_1;
                        gameState = ESCAPE_LVL_1;
                        next_rgb <= rgb_level1;
                        //letter <= " ";
                    end
                    else begin
                        nextState = START_PAGE;
                        gameState = START_PAGE;
                        next_rgb <= rgb_start;
                    end
                PRACTICE_MODE: begin
                        nextState = PRACTICE_MODE;
                        gameState = PRACTICE_MODE;
                        next_rgb <= rgb_practice;
                   end
                ESCAPE_LVL_1:
                    if (posEdgeDash && lvl_1_done) begin
                        nextState = ESCAPE_LVL_2;
                        gameState = ESCAPE_LVL_2;
                        next_rgb <= rgb_level2;
                        //letter <= " ";
                    end
                    else begin
                        nextState = ESCAPE_LVL_1;
                        gameState = ESCAPE_LVL_1;
                        next_rgb <= rgb_level1;
                    end
                ESCAPE_LVL_2:
                    if (posEdgeDash && lvl_2_done) begin
                        nextState = ESCAPE_LVL_3;
                        gameState = ESCAPE_LVL_3;
                        next_rgb <= rgb_level3;
                        //letter <= " ";
                    end
                    else begin
                        nextState = ESCAPE_LVL_2;
                        gameState = ESCAPE_LVL_2;
                        next_rgb <= rgb_level2;
                    end 
                ESCAPE_LVL_3:
                    if (posEdgeDash && lvl_3_done) begin
                        nextState = DONE;
                        gameState = DONE;
                        next_rgb <= rgb_done;
                        //letter <= " ";
                    end
                    else begin
                        nextState = ESCAPE_LVL_3;
                        gameState = ESCAPE_LVL_3;
                        next_rgb <= rgb_level3;
                    end 
                DONE: begin
                    nextState = DONE;
                    gameState = DONE;
                    next_rgb <= rgb_done;
                end    
             endcase
         end
         
    // update screen
    always @(posedge newClk) begin
            rgb <= next_rgb;
   end 
            
endmodule