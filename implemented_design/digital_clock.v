// Digital Clock Module
module digital_clock (
    input wire clk_1hz,                      // 1 Hz clock signal (ticks once per second)
    input time_reset,                   // Reset to initial time
    input time_pause,                   // Stop/start time signal
    input time_set,                     // Load the time from time_in input
    input [16:0] time_in,               // Input time in the format hhhhh:mmmmmm:ssssss (5 bits for hours, 6 bits for minutes, 6 bits for seconds)
    input hour_inc,                     // Increment hour button
    input hour_dec,                     // Decrement hour button
    input min_inc,                      // Increment minute button
    input min_dec,                      // Decrement minute button
    input [5:0] set_sec,                // Set seconds via switches
    output [4:0] hour_out,              // 5-bit hour output to feed the calendar module
    output [5:0] sec_out,               // 6-bit seconds output to display using LEDs
    output [3:0] sec_1s, sec_10s,       // BCD outputs for seconds
    output [3:0] min_1s, min_10s,       // BCD outputs for minutes
    output [3:0] hr_1s, hr_10s          // BCD outputs for hours
);

    // Separate the input time into hours, minutes, and seconds
    wire [5:0] sec_in, min_in;
    wire [4:0] hour_in;
    assign {hour_in, min_in, sec_in} = time_in;
    
    // Registers to store the current time
    reg [5:0] sec_reg, min_reg;
    reg [4:0] hour_reg;
    
    // Load initial time or reset time
   always @(posedge clk_1hz) begin
    if (time_reset) begin
        sec_reg <= 25;
        min_reg <= 30;
        hour_reg <= 23;
    end 
    else if (time_set) begin
        sec_reg <= sec_in;
        min_reg <= min_in;
        hour_reg <= hour_in;
    end 
    else if (!time_pause) begin
        // Handle seconds
        if (sec_reg == 6'd59) begin
            sec_reg <= 6'd0; // Wrap around to 0 after 59 seconds
            // Handle minutes
            if (min_reg == 6'd59) begin
                min_reg <= 6'd0; // Wrap around to 0 after 59 minutes
                // Handle hours
                if (hour_reg == 5'd23) begin
                    hour_reg <= 5'd0; // Wrap around to 0 after 23 hours
                end else begin
                    hour_reg <= hour_reg + 1;
                end
            end else begin
                min_reg <= min_reg + 1;
            end
        end else begin
            sec_reg <= sec_reg + 1;
        end
    end 
    else begin
        // Time is paused, allow manual adjustments
        if (hour_inc) begin
            if (hour_reg == 5'd23) begin
                hour_reg <= 5'd0;
            end else begin
                hour_reg <= hour_reg + 1;
            end
        end
        if (hour_dec) begin
            if (hour_reg == 5'd0) begin
                hour_reg <= 5'd23;
            end else begin
                hour_reg <= hour_reg - 1;
            end
        end
        if (min_inc) begin
            if (min_reg == 6'd59) begin
                min_reg <= 6'd0;
            end else begin
                min_reg <= min_reg + 1;
            end
        end
        if (min_dec) begin
            if (min_reg == 6'd0) begin
                min_reg <= 6'd59;
            end else begin
                min_reg <= min_reg - 1;
            end
        end
        if (set_sec <= 6'd59) begin
            sec_reg <= set_sec;
        end else begin
            sec_reg <= 6'd0;
        end
    end
end


    // Convert binary values to output BCD values
    assign hour_out = hour_reg;
    assign sec_out = sec_reg;
    assign sec_10s = sec_reg / 10;
    assign sec_1s  = sec_reg % 10;
    assign min_10s = min_reg / 10;
    assign min_1s  = min_reg % 10;
    assign hr_10s  = hour_reg / 10;
    assign hr_1s   = hour_reg % 10;    

endmodule
