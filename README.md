# Morse Code Escape Game🕹️
EC311 
Morse Code Escape Game 
Group 4: Ella Conley, Siara Patel, Tyler Nguyen, Nathan Strahs

This README provides an in-depth explanation of the provided verilog modules and how they interact together. The vga controller and vga rom were adapted from a github repository from FPGADude. 

Link to Project Demo Video: 

Table of Contents: 
Overview of Project
How to run your project 
Main Modes 
Module Descriptions 
Integration of Modules
Final Block Diagram 
References

Overview of Project:
Four switches are assigned to four different modes, with the start_page_display displaying this 
Switch 0 corresponds to practice mode from the practice_display module 
This mode allows the user to display a variety of letters based on their morse code input. 
Switch 1 corresponds to level 1 
User has to input the word “Logic” if incorrect input the letter will display in the color red, if correct the letter will be green.  
Switch 2 corresponds to level 2 
User has to input the phrase “BU Engineering” with the same color error indications. 
Switch 3 corresponds to level 3 
User has to input the sentence “The quick brown fox jumps over the lazy dog” with the same color error indications. 
Important Note: the user must reset the module after completing it. Additionally, after inputting all the correct letters, the user then clicks done to have the done page display.

How to run the project: upload the bitstream and follow the instructions on the main page.

Main Modes: 
Practice Mode
Level 1 
Level 2 
Level 3  



Module Descriptions 
fms_top.v
Contains a finite state machine for page/level displays. 
States include: START_PAGE, PRACTICE_MODE, ESCAPE_LVL_1, ESCAPE_LVL_2, ESCAPE_LVL_3, DONE_PAGE_DISPLAY, and the three debouncers. 
The state transition logic depends on which switch the user selects for the desired mode: practice, level 1, level 2, or level 3. 
A counter variable is used to count the number of letter inputs the user has entered on the positive edge of each input. 

morseTrie.v
FSM logic for how user input translates to letter output.
This module checks if the user inputted a dot or dash and the current letter to increment to the correct letter. 
The inputs are stored in an output register called currLetter, and the register morseLetter is set if the done button is pressed. 

vga_controller.v (found on github FPGADude and then modified)
Iterates and checks pixels of the vga monitor to ensure the monitor is in the right area to display. 
In this module we also have a clock divider that generates a 25MHz from 100MHz. 

start_page_display.v
Includes vga start page display code. 

practice_display.v
For practice mode, allowing users to input morse code letters and display them on the vga. 

level_1_display.v
Includes “LEVEL 1” and “LOGIC” for users to match word logic.
To check if the user input is correct, a counter, prevCheck, and letter variable are used. Counter and prevCheck are checked to indicate what position in the word the user is in and if the letter position and letter imputed matches the letter in the if statement, rbg, which sets the vga, is set to green. If not, the correct letter will display but in the color red.

level_2_display.v 
For level 2, includes “LEVEL 2” and “BU ENGINEERING” for users to match this expression.
Same logic as level 1 to check the letters for this level. 

level_3_display.v 
For level 3,  includes “LEVEL 3” and “THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG.”
Same logic as level 1 to check the letters for this level. 

done_page_display.v
Done display page. 
Displays only if the user gets all inputs correct for a given word/statement. 

debouncer.v
Three debouncer modules. 
Outputs posedge and high button. 
Posedge is only on for one clock cycle. 


ascii_test.v 
Letter stores the user input morse code and converts it into the equivalent ascii character (ascii_char).

ascii_rom.v 
Defines/maps the pixels for the vga to display letters. 

const_ascii_test.xdc
Switches → practice, lvl_1, lvl_2, lvl_3
LEDs → counter [0:7]
Buttons → done, reset, dot, dash 
rgb [0:11]

Integration of the Modules: 
Top Module (fsm_top.v) 

Instanciates morseTrie, vga_controller, start_page_display, level_1_display, level_2_display, level_3_display, done_page_display, debouncer.
	
Many of the modules depend on the clk, video_on, x, y, and letter. Video_on, x, y come are outputted by the vga controller module. Letter outputted by the morseTrie module. The x and y variables indicate where the content will display, thus each of the display pages rely on that. Letter is taken as an input to this display modules as well because it indicated what letter to display
The outputs of the level_displays set rgb_level _#, either 1, 2, or 3, in the state machine logic below. Depending on the mode or level the user is in, the next_state and next_rbg are set. At each clk cycle, rgb is set to next_rbg to display the desired output.

Debouncing 
 	
Instantiate the debouncer three times and use the output for checking the posEdge of the buttons to determine if dot, dash, or done was selected.

Letter Mapping (ascii_rom) 

Maps the pixels for 26 letters.

Final Block Diagram: 

![alt text](/Final_BlockDiagram.jpg)

References: 
https://github.com/FPGADude/Digital-Design/tree/main/FPGA%20Projects/VGA%20Projects/VGA%20Text%20Generation 

   
**5. References:**   
[https://github.com/FPGADude/Digital-Design/tree/main/FPGA%20Projects/VGA%20Projects/VGA%20Text%20Generation](https://github.com/FPGADude/Digital-Design/tree/main/FPGA%20Projects/VGA%20Projects/VGA%20Text%20Generation) 
