`timescale 1ns / 1ps

module vga_controller(
    input clk,               // 25 MHz clock (or higher)
    input reset,             // Reset signal
    output reg [9:0] x,      // Current pixel X position (0-639)
    output reg [9:0] y,      // Current pixel Y position (0-479)
    output reg hsync,        // Horizontal Sync signal
    output reg vsync,        // Vertical Sync signal
    output reg video_on      // Video signal indicating if the pixel is within visible area
);
    // VGA 640x480 60Hz timing parameters
    parameter H_SYNC_CYCLES = 96;
    parameter H_BACK_PORCH = 48;
    parameter H_ACTIVE_VIDEO = 640;
    parameter H_FRONT_PORCH = 16;
    parameter H_TOTAL_CYCLES = 800;

    parameter V_SYNC_CYCLES = 2;
    parameter V_BACK_PORCH = 33;
    parameter V_ACTIVE_VIDEO = 480;
    parameter V_FRONT_PORCH = 10;
    parameter V_TOTAL_CYCLES = 525;

    reg [9:0] h_count;
    reg [9:0] v_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h_count <= 0;
            v_count <= 0;
            x <= 0;
            y <= 0;
            hsync <= 0;
            vsync <= 0;
            video_on <= 0;
        end else begin
            // Horizontal counter
            if (h_count < H_TOTAL_CYCLES - 1)
                h_count <= h_count + 1;
            else
                h_count <= 0;

            // Vertical counter
            if (h_count == H_TOTAL_CYCLES - 1) begin
                if (v_count < V_TOTAL_CYCLES - 1)
                    v_count <= v_count + 1;
                else
                    v_count <= 0;
            end

            // Generate hsync, vsync, and video_on signals
            if (h_count < H_SYNC_CYCLES)
                hsync <= 0;
            else
                hsync <= 1;

            if (v_count < V_SYNC_CYCLES)
                vsync <= 0;
            else
                vsync <= 1;

            // Video is on if within active video area
            if (h_count >= (H_SYNC_CYCLES + H_BACK_PORCH) && h_count < (H_SYNC_CYCLES + H_BACK_PORCH + H_ACTIVE_VIDEO) &&
                v_count >= (V_SYNC_CYCLES + V_BACK_PORCH) && v_count < (V_SYNC_CYCLES + V_BACK_PORCH + V_ACTIVE_VIDEO)) begin
                video_on <= 1;
                x <= h_count - (H_SYNC_CYCLES + H_BACK_PORCH);
                y <= v_count - (V_SYNC_CYCLES + V_BACK_PORCH);
            end else begin
                video_on <= 0;
                x <= 0;
                y <= 0;
            end
        end
    end
endmodule
