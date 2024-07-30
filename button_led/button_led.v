`timescale 1ns / 1ps

module button_led(
    input main_clock, // 100 Mhz clock source on Basys 3 FPGA
    input reset, // reset
    input [5:0]second_input,
    output reg [5:0] button_led_out
    );
    
    always@(*)
    begin
        if(reset == 1'b1)
            button_led_out = 6'd0;
        else
            button_led_out = second_input[5:0];
    end
    
    
endmodule
