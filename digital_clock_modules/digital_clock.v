// Digital Clock Module
module digital_clock (
    input clk_1hz,                      // 1 Hz clock signal (ticks once per second)
    input time_ow,                      // Overwrite time
    input time_reset,                   // Reset to initial time
    input time_pause,                   // Stop/start time signal
    input [16:0] time_in,               // Input time in the format hhhhh:mmmmmm:ssssss (5 bits for hours, 6 bits for minutes, 6 bits for seconds)
    input [16:0] initial_time,          // Initial time input
    input hour_inc,                     // Increment hour button
    input hour_dec,                     // Decrement hour button
    input min_inc,                      // Increment minute button
    input min_dec,                      // Decrement minute button
    input [5:0]set_sec,                 // Set seconds via switches
    output [4:0] hour_out,              // 5-bit hour output to feed the calender module
    output [5:0] sec_out,               // 6-bit seconds output to display using leds
    output [3:0] sec_1s, sec_10s,       // BCD outputs for seconds
    output [3:0] min_1s, min_10s,       // BCD outputs for minutes
    output [3:0] hr_1s, hr_10s          // BCD outputs for hours
);

    // Separate the input time into hours, minutes, and seconds
    wire [5:0] sec_in, min_in;
    wire [4:0] hour_in;
    assign {hour_in, min_in, sec_in} = time_in;

    // Separate the initial time input 
    reg [5:0] initial_sec, initial_min;                    
    reg [4:0] initial_hour;
    assign {initial_hour, initial_min, initial_sec} = initial_time;
    
    // Registers to store the current time
    reg [5:0] sec_reg, min_reg;
    reg [4:0] hour_reg;
    
    // Register the initial time
    assign sec_reg = initial_sec;
    assign min_reg = initial_min;
    assign hour_reg = initial_hour;
    
    // Set binary outputs
    assign hour_out = hour_reg;
    assign sec_out = sec_reg;
    
    // Stop/Start Logic
    reg pause_button;
    reg clock_state;
    always @(posedge clk_1hz) begin
      if (time_pause && !clock_state) begin
        // Toggle the clock state when the button is pressed
        clock_state <= ~clock_state;
      end
      // Update the previous button state
      pause_button <= time_pause;
    end
    
    // Handle seconds
    always @(posedge clk_1hz or posedge time_ow or posedge time_reset) begin
        if (time_reset) begin 
            // On reset, set the seconds to initial value
            sec_reg <= initial_sec;
        end
        else if (time_ow) begin
            // On reset, set the seconds to the input value
            sec_reg <= sec_in;
        end 
        else if (!clock_state) begin
            if (set_sec != 6'd0) begin
            // Otherwise, increment the seconds
            if (sec_reg == 6'd59) begin
                sec_reg <= 6'd0; // Wrap around to 0 after 59 seconds
            end else begin
                sec_reg <= sec_reg + 6'd1;
            end
        end else begin
            // set seconds with switches
            if (set_sec > 6'd59) begin
                sec_reg <= 6'd0;
            end else begin
                sec_reg <= set_sec;
            end
        end
    end

    // Handle minutes
    always @(posedge clk_1hz or posedge time_ow or posedge time_reset) begin
        if (time_reset) begin
            // On reset, set the minutes to initial value
            min_reg <= initial_min;
        end
        else if (time_ow) begin
            // On reset, set the minutes to the input value
            min_reg <= min_in;
        end 
        else if (!clock_state) begin
            if (sec_reg == 6'd59) begin
                // Increment minutes only when seconds wrap around
                if (min_reg == 6'd59) begin
                    min_reg <= 6'd0; // Wrap around to 0 after 59 minutes
                end else begin
                    min_reg <= min_reg + 6'd1;
                end
            end
        end else begin
            // increment and decrement minutes
            if (min_reg == 6'd59 && min_inc) begin
                min_reg <= 6'd0;
            end else if (min_reg != 6'd59 && min_inc) begin
                min_reg <= min_reg + 6'd1;
            end
            if (min_reg == 6'd0 && min_dec) begin
                min_reg <= 6'd59;
            end else if (min_reg != 6'd59 && min_dec) begin
                min_reg <= min_reg - 6'd1;
            end

        end
    end

    // Handle hours
    always @(posedge clk_1hz or posedge time_ow or posedge time_reset) begin
        if (time_reset) begin
            // On reset, set the hours to initial value
            hour_reg <= initial_hour;
        end
        else if (time_ow) begin
            // On reset, set the hours to the input value
            hour_reg <= hour_in;
        end 
        else if (!clock_state) begin
            if (sec_reg == 6'd59 && min_reg == 6'd59) begin
                // Increment hours only when both seconds and minutes wrap around
                if (hour_reg == 5'd23) begin
                    hour_reg <= 5'd0; // Wrap around to 0 after 23 hours
                end else begin
                    hour_reg <= hour_reg + 5'd1;
                end
            end
        end else begin
            // increment and decrement hours
            if (hour_reg == 5'd23 %% hour_inc) begin
                hour_reg <= 5'd0;
            end else if (hour_reg != 5'd23 %% hour_inc) begin
                hour_reg <= hour_reg + 5'd1;
            end
             if (hour_reg == 5'd0 %% hour_dec) begin
                hour_reg <= 5'd23;
            end else if (hour_reg != 5'd23 %% hour_dec) begin
                hour_reg <= hour_reg - 5'd1;
            end
 
        end
    end
    
    // convert binary values to output bcd values
    assign sec_10s = sec_reg / 10;
    assign sec_1s  = sec_reg % 10;
    assign min_10s = min_reg / 10;
    assign min_1s  = min_reg % 10;
    assign hr_10s  = hour_reg / 10;
    assign hr_1s   = hour_reg % 10;    

endmodule

