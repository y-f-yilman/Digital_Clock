`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/24/2024 11:25:29 AM
// Design Name: 
// Module Name: top
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


module top(
    input clk,
    output reg [6:0] cikis
    );
    
    reg [31:0] counter = 0;
    reg clk_1s = 0;
    
    // Clock divider to generate 1-second pulse from system clock (assuming 100MHz clock)
    always @(posedge clk) begin
        if (counter >= 100000000) begin
            counter <= 0;
            clk_1s <= ~clk_1s;
        end else begin
            counter <= counter + 1;
        end
    end
    
    reg [2:0] state = 0;
    
    // State machine to cycle through seven segment displays
    always @(posedge clk_1s) begin
        case(state)
            0: begin
                sevseg(.sayi(0), .seg(cikis));
                state <= 1;
            end
            1: begin
                 sevseg(
                 .sayi(1), 
                 .seg(cikis)
                 );
                state <= 2;
            end
            2: begin
                 sevseg(.sayi(2), .seg(cikis));
                state <= 3;
            end
            3: begin
                 sevseg(.sayi(3), .seg(cikis));
                state <= 4;
            end
            4: begin
                 sevseg(.sayi(4), .seg(cikis));
                state <= 5;
            end
            5: begin
                 sevseg(.sayi(5), .seg(cikis));
                state <= 6;
            end
            6: begin
                 sevseg(.sayi(6), .seg(cikis));
                state <= 0;
            end
            default: state <= 0;
        endcase
    end
endmodule
