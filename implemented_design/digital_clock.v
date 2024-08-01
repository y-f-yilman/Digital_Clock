
// Digital Clock Module
module digital_clock (
    input clk_1hz,                      // 1 Hz clock signal (ticks once per second)
    //input time_ow,                      // Overwrite time
    input time_reset,                   // Reset to initial time
    input time_pause,                   // Stop/start time signal
    //input [16:0] time_in,               // Input time in the format hhhhh:mmmmmm:ssssss (5 bits for hours, 6 bits for minutes, 6 bits for seconds)
    //input [16:0] initial_time,          // Initial time input
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
    //wire [5:0] sec_in, min_in;
    //wire [4:0] hour_in;
    //assign {hour_in, min_in, sec_in} = time_in;

    // Separate the initial time input 
    //reg [5:0] initial_sec, initial_min;                    
    //reg [4:0] initial_hour;
    //assign {initial_hour, initial_min, initial_sec} = initial_time;
    
    // Registers to store the current time
    reg [5:0] sec_reg, min_reg;
    reg [4:0] hour_reg;
    
    // Register the initial time
    //assign sec_reg = initial_sec;
    //assign min_reg = initial_min;
    //assign hour_reg = initial_hour;
    
    // Set binary outputs
    assign hour_out = hour_reg;
    assign sec_out = sec_reg;
    
     //Stop/Start Logic
    wire clock_state;
    reg clock_state_db1, clock_state_db2, clock_state_db3 = 0;
    always @(posedge clk_1hz) begin
      if (time_pause) begin
        // Toggle the clock state when the button is pressed
        clock_state_db1 <= ~clock_state_db1;
        clock_state_db2 <= clock_state_db1;
        clock_state_db3 <= clock_state_db2;
      end
    end
    assign clock_state = clock_state_db3;
    
    // Handle seconds
    always @(posedge clk_1hz) begin
        if (time_reset) begin
            sec_reg <= 0;
        end
        // Otherwise, increment the seconds
        else if (!clock_state) begin
            if (sec_reg == 6'd59) begin
                sec_reg <= 6'd0; // Wrap around to 0 after 59 seconds
            end else begin
                sec_reg <= sec_reg + 6'd1;
            end       
        end else begin
            if (set_sec > 6'd59) begin
                sec_reg <= 6'd0;
            end else begin
                sec_reg <= set_sec;
            end
        end              
    end

    // Handle minutes
    always @(posedge clk_1hz) begin
        if (time_reset) begin
            min_reg <= 0;
        end
        else if ((sec_reg == 6'd59 && !clock_state) | (clock_state && min_inc)) begin
            // Increment minutes only when seconds wrap around
            if (min_reg == 6'd59) begin
                min_reg <= 6'd0; // Wrap around to 0 after 59 minutes
            end else begin
                min_reg <= min_reg + 1;
            end
        end else if (clock_state && min_dec) begin
            if (min_reg == 6'd0) begin
                min_reg <= 6'd59;
            end else begin
                min_reg <= min_reg - 1;
            end
        end
    end


    // Handle hours
    always @(posedge clk_1hz) begin
        if (time_reset) begin
            hour_reg <= 0;
        end
        else if (((sec_reg == 6'd59 && min_reg == 6'd59) && !clock_state) | (clock_state && hour_inc)) begin
            // Increment hours only when both seconds and minutes wrap around
            if (hour_reg == 5'd23) begin
                hour_reg <= 5'd0; // Wrap around to 0 after 23 hours
            end else begin
                hour_reg <= hour_reg + 1;
            end
        end else if (clock_state && hour_dec) begin
            if (hour_reg == 5'd0) begin
                hour_reg <= 5'd23;
            end else begin
                hour_reg <= hour_reg - 1;
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


