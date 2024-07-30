`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2024 11:27:28 AM
// Design Name: 
// Module Name: ss_dc
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


`timescale 1ns / 1ps

module ss_dc(
    input wire clk,
    input rst,
//    input wire time_ow,
//    input wire [16:0] time_in,
    output wire [6:0] seg,
    output wire [3:0] an
);
    reg [16:0]start_time;
    wire clk_1hz;
    wire [4:0] hour_out;
    wire [3:0] sec_1s, sec_10s;
    wire [3:0] min_1s, min_10s;
    wire [3:0] hr_1s, hr_10s;
    
    always @(*)begin
        start_time[16:12] = 5'd12;
        start_time[11:6] = 6'd30;
        start_time[5:0] =  6'd0;
    end
    
    clock_divide clk_div(
    .clk(clk), 
    .clk_1hz(clk_1hz)
    );
    
    digital_clock clock(
        .clk_1hz(clk_1hz),
//        .time_ow(time_ow),
        .time_in(),
        .hour_out(hour_out),
        .sec_1s(sec_1s),
        .sec_10s(sec_10s),
        .min_1s(min_1s),
        .min_10s(min_10s),
        .hr_1s(hr_1s),
        .hr_10s(hr_10s)
    );
    
    deneme_seven display(
        .clk(clk),
        .sec_1s(sec_1s),
        .sec_10s(sec_10s),
        .min_1s(min_1s),
        .min_10s(min_10s),
        .hr_1s(hr_1s),
        .hr_10s(hr_10s),
        .seg(seg),
        .an(an)
    );
   
    
    
endmodule

