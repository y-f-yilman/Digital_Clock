`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2024 05:48:25 PM
// Design Name: 
// Module Name: module_uart_filo
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

module uart_filo
    #(
        parameter DBIT = 8,       // number of data bits
                  SB_TICK = 16,   // number of ticks for stop bit, assuming 16x oversampling
                  N = 10,         // number of counter bits for baud rate generator
                  M = 651         // counter limit value for baud rate generator (9600 baud)
    )
    (
        input wire clk,           // clock input
        input wire reset,         // reset input
        input wire rx,            // serial data input
        input wire start,         // start signal for outputting the data
        output wire tx,           // serial data output
        output wire done          // done signal indicating transmission completed
    );

    // Internal signals
    wire s_tick;
    wire [7:0] rx_data;
    wire rx_done_tick;
    reg [3:0] char_count;
    reg [7:0] mem [0:15];          // Memory to store 16 characters
    reg [3:0] read_ptr;            // Read pointer for FILO
    reg [3:0] write_ptr;           // Write pointer for storing characters
    reg tx_start;
    reg [7:0] tx_data;
    reg done_reg;

    // Instantiate the baud rate generator
    baud_rate_generator #(.N(N), .M(M)) baud_gen
    (
        .clk_100MHz(clk),
        .reset(reset),
        .tick(s_tick)
    );

    // Instantiate the UART receiver
    uart_rx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_receiver
    (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .s_tick(s_tick),
        .dout(rx_data),
        .rx_done_tick(rx_done_tick)
    );

    // Receive and store characters
    always @(posedge clk or posedge reset)
    begin
        if (reset)
        begin
            char_count <= 0;
            write_ptr <= 0;
        end
        else if (rx_done_tick && char_count < 16)
        begin
            mem[write_ptr] <= rx_data;
            write_ptr <= write_ptr + 1;
            char_count <= char_count + 1;
        end
    end

    // Transmission logic
    always @(posedge clk or posedge reset)
    begin
        if (reset)
        begin
            read_ptr <= 0;
            tx_start <= 0;
            done_reg <= 0;
        end
        else if (start && !tx_start)
        begin
            if (char_count > 0)
            begin
                read_ptr <= (write_ptr == 0) ? 15 : write_ptr - 1;
                tx_data <= mem[(write_ptr == 0) ? 15 : write_ptr - 1];
                tx_start <= 1;
                done_reg <= 0;
            end
        end
        else if (tx_start)
        begin
            // Transmission process
            if (char_count > 1)
            begin
                tx_data <= mem[read_ptr];
                read_ptr <= (read_ptr == 0) ? 15 : read_ptr - 1;
                char_count <= char_count - 1;
            end
            else
            begin
                tx_start <= 0;
                done_reg <= 1;
            end
        end
    end

    // Output the transmission data and status
    assign tx = tx_data;
    assign done = done_reg;

endmodule
