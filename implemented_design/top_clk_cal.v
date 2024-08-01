`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Authored by David J. Marion aka FPGA Dude
// Created on 4/14/2022
//
// Synopsis: Simulating a binary clock with a calendar. The binary clock
// drives the calendar through the w_end_of_day signal.
//////////////////////////////////////////////////////////////////////////////////

module top_clk_cal(
    input clk_100MHz,
//    input [20:0] date_input,
//    input [16:0] time_input,
//    input [16:0] initial_time,
//    input over_write,                                                   // over write signal
    input reset,                                                        // reset switch
    input switch_15, switch_14, switch_13,                              // set clock speed
    input switch_0, switch_1, switch_2, switch_3, switch_4, switch_5,   // set seconds
    input pause, inc_hour, inc_minute, dec_hour, dec_minute,            // M-button / U-button / R-button / D-button / L-button
    output [5:0] sec_out,                                               // second outputs
    output [3:0] hr_10s, hr_1s, min_10s, min_1s, sec_10s, sec_1s,       // clock outputs
    output [3:0] d_10s, d_1s, m_10s, m_1s, y_10s, y_1s, c_10s, c_1s     // calendar outputs
);

    wire clk;
    wire [5:0] set_sec;
    wire [4:0] hour_out;

    assign set_sec = {switch_5, switch_4, switch_3, switch_2, switch_1, switch_0};

    clock_divider clk_div(
        .clk(clk_100MHz),
        .switch_x10(switch_13),
        .switch_x100(switch_14),
        .switch_x1000(switch_15),
        .clk_hz(clk)
    );

    digital_clock clock(
        .clk_1hz(clk),              
        //.time_ow(over_write),       
        .time_reset(reset),         
        .time_pause(pause),         
        //.time_in(time_input),       
        //.initial_time(initial_time),
        .hour_inc(inc_hour),        
        .hour_dec(dec_hour),        
        .min_inc(inc_minute),       
        .min_dec(dec_minute),       
        .set_sec(set_sec),              
        .hour_out(hour_out),         
        .sec_out(sec_out),             
        .sec_1s(sec_1s),
        .sec_10s(sec_10s),     
        .min_1s(min_1s),
        .min_10s(min_10s),     
        .hr_1s(hr_1s),
        .hr_10s(hr_10s)        
    );

    digital_calendar cal(
        .clk(clk),
        //.date_ow(over_write),
        .hour_in(hour_out),                                  
        //.date_in(date_input),                       
        .day_1s(d_1s),
        .day_10s(d_10s),                        
        .month_1s(m_1s),
        .month_10s(m_10s),                    
        .year_1s(y_1s),
        .year_10s(y_10s),
        .year_100s(c_1s),
        .year_1000s(c_10s)
    );
    
endmodule

