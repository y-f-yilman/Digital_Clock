`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2024 10:42:03 AM
// Design Name: 
// Module Name: clock_divider
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


module clock_divider(
input clk,
output reg clk1hz
    );
    
    reg [26:0] counter;
    
    always @(posedge clk)begin
        counter <= counter +1;
        if(counter >= 50000000)begin
            clk1hz <= ~clk1hz;
            counter <= 0;
        end
    end
endmodule
