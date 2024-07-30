`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2024 01:09:26 PM
// Design Name: 
// Module Name: clock_divide
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



module clock_divide(
    input wire clk,    // 100 MHz clock input
    output reg clk_1hz // 1 Hz clock output
);
    reg [26:0] counter = 0;
    
    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter >= 50000000) begin // 100M / 2 = 50M
            clk_1hz <= ~clk_1hz;
            counter <= 0;
        end
    end
endmodule
