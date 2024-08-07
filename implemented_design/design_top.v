`timescale 1ns / 1ps

module design_top(
    input clk_100MHz,                                                   // 100MHz from Basys 3
    input switch_15,                                                    // sw[15], 1000Hz
    input switch_14,                                                    // sw[14], 100Hz
    input switch_13,     
    input overwrite,                                                    // sw[13], 10Hz
    input reset,                                                        // sw[12], sys reset
    input switch_0, switch_1, switch_2, switch_3, switch_4, switch_5,   // set seconds
    input pause,                                                        // btnC, pause/unpause clock       
    input inc_hr,                                                       // btnU, increment hour
    input inc_min,                                                      // btnR, increment minute
    input dec_hr,                                                       // btnD, decrement hour
    input dec_min,                                                      // btnL, decrement minute
    input rx,                                                           // UART receiver input
    output hsync,                                                       // to VGA Connector
    output vsync,                                                       // to VGA Connector
    output [11:0] rgb,                                                  // to DAC, to VGA Connector
    output [6:0] seg,                                                   // 7 Segment Display
    output [3:0] an,                                                    // 7SD-Anodes
    output [5:0] leds,                                                  // ld[0-5], 6 leds to indicate seconds
    output tx                                                           // UART transmitter output
);
    
    // Internal signals
    wire [9:0] w_x, w_y;
    wire video_on, p_tick;
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next;
    wire [3:0] hr_10s, hr_1s, min_10s, min_1s, sec_10s, sec_1s;
    wire [3:0] m_10s, m_1s, d_10s, d_1s, c_10s, c_1s, y_10s, y_1s;
    wire [20:0] date_out;
    wire [16:0] time_out;
    wire s_tick;
    wire [151:0] serial_out;
    wire [127:0] stream_out;     // UART 16-byte data storage
    wire data_ready;
    wire rx_done_tick;

    // Baud rate generator instance
    baud_rate_generator #(
        .N(10),
        .M(651)
    ) baud_gen_inst (
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .tick(s_tick)
    );

    // UART 16-byte storage instance
    uart_16_byte_store uart_store_inst (
        .clk(clk_100MHz),
        .reset(reset),
        .rx(rx),
        .s_tick(s_tick),
        .rx_data(),
        .rx_done_tick(rx_done_tick),
        .stream_out(stream_out),
        .data_ready(data_ready)
    );

    // UART demodulation instance
    uart_demod hikmet (
        .clk(clk_100MHz),
        .serial_in(stream_out), // Connecting UART storage output
        .time_ow(data_ready),   // Trigger demodulation when data is ready
        .date_out(date_out),
        .time_out(time_out)
    );

    // VGA controller instance
    vga_controller vgc (
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .video_on(video_on),
        .hsync(hsync),
        .vsync(vsync),
        .p_tick(p_tick),
        .x(w_x),
        .y(w_y)
    );

    // Pixel generator instance
    pixel_gen pg (
        .clk(clk_100MHz),
        .video_on(video_on),
        .x(w_x),
        .y(w_y),
        .sec_10s(sec_10s),
        .sec_1s(sec_1s),
        .min_10s(min_10s),
        .min_1s(min_1s),
        .hr_10s(hr_10s),
        .hr_1s(hr_1s),
        .m_10s(m_10s),
        .m_1s(m_1s),
        .d_10s(d_10s),
        .d_1s(d_1s),
        .y_10s(y_10s),
        .y_1s(y_1s),
        .c_10s(c_10s),
        .c_1s(c_1s),
        .rgb(rgb_next)
    );

    // Clock and calendar module instance
    top_clk_cal clk_and_cal (
        .clk_100MHz(clk_100MHz),
        .date_input(date_out),
        .time_input(time_out),
        .reset(reset),
        .switch_15(switch_15),
        .switch_14(switch_14),
        .switch_13(switch_13),
        .switch_11(rx_done_tick),
        .switch_0(switch_0),
        .switch_1(switch_1),
        .switch_2(switch_2),
        .switch_3(switch_3),
        .switch_4(switch_4),
        .switch_5(switch_5),
        .pause(pause),
        .inc_hour(inc_hr),
        .inc_minute(inc_min),
        .dec_hour(dec_hr),
        .dec_minute(dec_min),
        .sec_out(leds),
        .hr_10s(hr_10s),
        .hr_1s(hr_1s),
        .min_10s(min_10s),
        .min_1s(min_1s),
        .sec_10s(sec_10s),
        .sec_1s(sec_1s),
        .m_10s(m_10s),
        .m_1s(m_1s),
        .d_10s(d_10s),
        .d_1s(d_1s),
        .y_10s(y_10s),
        .y_1s(y_1s),
        .c_10s(c_10s),
        .c_1s(c_1s)
    );

    // 7-segment display driver instance
    seven_segment sev_seg (
        .clk(clk_100MHz),
        .sec_1s(sec_1s),
        .sec_10s(sec_10s),
        .min_1s(min_1s),
        .min_10s(min_10s),
        .hr_1s(hr_1s),
        .hr_10s(hr_10s),
        .seg(seg),
        .an(an)
    );

    // RGB buffer for VGA output
    always @(posedge clk_100MHz) begin
        if(p_tick)
            rgb_reg <= rgb_next;
    end
            
    assign rgb = rgb_reg;

endmodule
