`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/24/2024 11:23:14 AM
// Design Name: 
// Module Name: sevseg
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


module sevseg(
input [2:0]sayi,
output reg [6:0]seg
    );
    reg hikmet;
    always @(sayi)begin
        hikmet <= sayi;
        seg[hikmet] <= 1'b1;
        #10;
        seg[hikmet] <= 1'b0;
    end
    
endmodule
