`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2024 11:51:37 AM
// Design Name: 
// Module Name: lettermap
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


module lettermap(
    input clk, 
    input [6:0]height,
    input [6:0]width, 
    input [9:0]xstart,
    input [8:0]ystart,
    input [9:0]x, // change to our purpose 
    input [9:0]y,  // change to our purpose 
    input  in_btn,
    output reg [7:0] ascii_value, // this will be an input for final version 
    output reg letter
    );
    
    // letter declarations not completely correct yet, example B requires up to six variables 
      wire E1, E2, E3, E4;
//    wire A1, A2, A3, A4, B1, B2, B3, B4, C1, C2, C3, C4, D1, D2, D3, D4, E1, E2, E3, E4, F1, F2, F3, F4, G1, G2, G3, G4, H1, H2, H3, H4;
//    wire I1, I2, I3, I4, J1, J2, J3, J4, K1, K2, K3, K4, L1, L2, L3, L4, M1, M2, M3, M4, N1, N2, N3, N4, O1, O2, O3, O4, P1, P2, P3, P4;
//    wire Q1, Q2, Q3, Q4, R1, R2, R3, R4, S1, S2, S3, S4, T1, T2, T3, T4, U1, U2, U3, U4, V1, V2, V3, V4, W1, W2, W3, W4, X1, X2, X3, X4, Y1, Y2, Y3, Y4, Z1, Z2, Z3, Z4;
    
    //Letter Mapping to start just E 
    assign E1 = ((x > xstart) & (y > ystart) & (x < (xstart+(width/5))) & (y < ystart + height)) ? 1 : 0;
    assign E2 = ((x >= xstart+(width/5)) & (y > ystart) & (x < xstart+(2*width/5)) & (y < ystart+ (height/5))) ? 1 : 0;
    assign E3 = ((x >= xstart+(width/5)) & (y > ystart+(2*width/5)) & (x < xstart+(2*width/5)) & (y < ystart+ (3*height/5))) ? 1 : 0;
    assign E4 = ((x >= xstart+(width/5)) & (y > ystart+(4*width/5)) & (x < xstart+(2*width/5)) & (y < ystart+(height/5))) ? 1 : 0;
    
    always @(posedge clk) begin
        if (in_btn) begin
             ascii_value <= 101;
        end else begin
             ascii_value <= 8'b0;
        end 
    end 
        
    always@(x,y)begin 
        case(ascii_value)
//           97: letter = A1+A2+A3+A4; 
//           98: letter = B1 + B2 + B3 + B4;  // b = 98
//           99: letter = C1 + C2 + C3 + C4;  // c = 99
//           100: letter = D1 + D2 + D3 + D4;  // d = 100
             101: letter = E1 + E2 + E3 + E4;  // e = 101
//           102: letter = F1 + F2 + F3 + F4;  // f = 102
//           103: letter = G1 + G2 + G3 + G4;  // g = 103
//           104: letter = H1 + H2 + H3 + H4;  // h = 104
//           105: letter = I1 + I2 + I3 + I4;  // i = 105
//           106: letter = J1 + J2 + J3 + J4;  // j = 106
//           107: letter = K1 + K2 + K3 + K4;  // k = 107
//           108: letter = L1 + L2 + L3 + L4;  // l = 108
//           109: letter = M1 + M2 + M3 + M4;  // m = 109
//           110: letter = N1 + N2 + N3 + N4;  // n = 110
//           111: letter = O1 + O2 + O3 + O4;  // o = 111
//           112: letter = P1 + P2 + P3 + P4;  // p = 112
//           113: letter = Q1 + Q2 + Q3 + Q4;  // q = 113
//           114: letter = R1 + R2 + R3 + R4;  // r = 114
//           115: letter = S1 + S2 + S3 + S4;  // s = 115
//           116: letter = T1 + T2 + T3 + T4;  // t = 116
//           117: letter = U1 + U2 + U3 + U4;  // u = 117
//           118: letter = V1 + V2 + V3 + V4;  // v = 118
//           119: letter = W1 + W2 + W3 + W4;  // w = 119
//           120: letter = X1 + X2 + X3 + X4;  // x = 120
//           121: letter = Y1 + Y2 + Y3 + Y4;  // y = 121
//           122: letter = Z1 + Z2 + Z3 + Z4;  // z = 122
           default: letter = 0;               // default case, if needed
        endcase
    end       
            
endmodule
