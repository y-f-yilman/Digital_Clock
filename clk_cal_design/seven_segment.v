`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2024 11:26:54 AM
// Design Name: 
// Module Name: deneme_seven
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

module seven_segment(
    input wire clk,
    input wire [3:0] sec_1s, sec_10s,
    input wire [3:0] min_1s, min_10s,
    input wire [3:0] hr_1s, hr_10s,
    
    output reg [6:0] seg,
    output reg [3:0] an
);

    reg [3:0] digit;
    reg [1:0] scan_counter; // 2-bit counter to cycle through 4 digits
    reg [16:0] refresh_counter = 0; // Counter for generating slower clock for refresh
    wire refresh_clk;
    
    // Generate a slower clock for refreshing the display
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end
    
    assign refresh_clk = refresh_counter[16]; // Divide the clock to slow down the refresh rate
    
    // Update scan_counter at the slower clock rate
    always @(posedge refresh_clk) begin
        scan_counter <= scan_counter + 1;
    end
    
    // Select the digit to display based on the scan counter
    always @(*) begin
        case (scan_counter)
            2'b00: digit = min_1s;
            2'b01: digit = min_10s;
            2'b10: digit = hr_1s;
            2'b11: digit = hr_10s;
            default: digit = 4'b0000;
        endcase
    end
    
    // Convert the selected digit to 7-segment display encoding
    always @(*) begin
        case(digit)
            4'b0000: seg = 7'b1000000; // 0
            4'b0001: seg = 7'b1111001; // 1
            4'b0010: seg = 7'b0100100; // 2
            4'b0011: seg = 7'b0110000; // 3
            4'b0100: seg = 7'b0011001; // 4
            4'b0101: seg = 7'b0010010; // 5
            4'b0110: seg = 7'b0000010; // 6
            4'b0111: seg = 7'b1111000; // 7
            4'b1000: seg = 7'b0000000; // 8
            4'b1001: seg = 7'b0010000; // 9
            default: seg = 7'b1111111; // Blank
        endcase
    end
    
    // Enable the appropriate anode for the selected digit
    always @(*) begin
        case (scan_counter)
            2'b00: an = 4'b1110; // Enable units
            2'b01: an = 4'b1101; // Enable tens
            2'b10: an = 4'b1011; // Enable hundreds
            2'b11: an = 4'b0111; // Enable thousands
            default: an = 4'b1111; // Disable all
        endcase
    end
    
endmodule
