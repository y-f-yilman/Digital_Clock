`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2024 15:30:31
// Design Name: 
// Module Name: uart_rx
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


module uart_rx (
    input wire clk,
    input wire reset,
    input wire rx, // UART receive pin
    output reg [7:0] data, // Received data byte
    output reg valid // Data valid signal
);
    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 50000000; // 50 MHz clock
    parameter BAUD_TICK = CLOCK_FREQ / BAUD_RATE;

    reg [15:0] baud_counter = 0;
    reg [3:0] bit_counter = 0;
    reg [7:0] rx_shift_reg;
    reg receiving = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            baud_counter <= 0;
            bit_counter <= 0;
            rx_shift_reg <= 0;
            receiving <= 0;
            valid <= 0;
        end else begin
            if (!receiving) begin
                if (rx == 0) begin // Start bit detected
                    receiving <= 1;
                    baud_counter <= BAUD_TICK / 2; // Align to middle of start bit
                end
            end else begin
                if (baud_counter == BAUD_TICK - 1) begin
                    baud_counter <= 0;
                    if (bit_counter == 8) begin // All bits received
                        data <= rx_shift_reg;
                        valid <= 1;
                        receiving <= 0;
                        bit_counter <= 0;
                    end else begin
                        rx_shift_reg <= {rx, rx_shift_reg[7:1]}; // Shift in data bit
                        bit_counter <= bit_counter + 1;
                    end
                end else begin
                    baud_counter <= baud_counter + 1;
                end
            end
        end
    end
endmodule

