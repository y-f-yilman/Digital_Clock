`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2024 15:31:02
// Design Name: 
// Module Name: uart_tx
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


module uart_tx (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data, // Data to transmit
    output reg tx, // UART transmit pin
    output reg busy // Transmitter busy signal
);
    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 50000000; // 50 MHz clock
    parameter BAUD_TICK = CLOCK_FREQ / BAUD_RATE;

    reg [15:0] baud_counter = 0;
    reg [3:0] bit_counter = 0;
    reg [9:0] tx_shift_reg;
    reg transmitting = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            baud_counter <= 0;
            bit_counter <= 0;
            tx_shift_reg <= 10'b1111111111;
            transmitting <= 0;
            busy <= 0;
            tx <= 1;
        end else begin
            if (!transmitting) begin
                if (start) begin
                    transmitting <= 1;
                    tx_shift_reg <= {1'b1, data, 1'b0}; // Start bit, data, stop bit
                    busy <= 1;
                end
            end else begin
                if (baud_counter == BAUD_TICK - 1) begin
                    baud_counter <= 0;
                    tx <= tx_shift_reg[0];
                    tx_shift_reg <= {1'b1, tx_shift_reg[9:1]}; // Shift out data bit
                    if (bit_counter == 10) begin // All bits transmitted
                        transmitting <= 0;
                        busy <= 0;
                        bit_counter <= 0;
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end else begin
                    baud_counter <= baud_counter + 1;
                end
            end
        end
    end
endmodule

