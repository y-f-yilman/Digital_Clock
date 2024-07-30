// Digital Clock Module
module digital_clock (
    input clk_1hz,                      // 1 Hz clock signal (ticks once per second)
    input time_ow,                      // Asynchronous reset signal to overwrite time
    input [16:0] time_in,               // Input time in the format hhhhh:mmmmmm:ssssss (5 bits for hours, 6 bits for minutes, 6 bits for seconds)
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

    // Handle seconds
    always @(posedge clk_1hz or posedge time_ow) begin
        if (time_ow) begin
            // On reset, set the seconds to the input value
            sec_reg <= sec_in;
        end else begin
            // Otherwise, increment the seconds
            if (sec_reg == 6'd59) begin
                sec_reg <= 6'd0; // Wrap around to 0 after 59 seconds
            end else begin
                sec_reg <= sec_reg + 6'd1;
            end
        end
    end

    // Handle minutes
    always @(posedge clk_1hz or posedge time_ow) begin
        if (time_ow) begin
            // On reset, set the minutes to the input value
            min_reg <= min_in;
        end else begin
            if (sec_reg == 6'd59) begin
                // Increment minutes only when seconds wrap around
                if (min_reg == 6'd59) begin
                    min_reg <= 6'd0; // Wrap around to 0 after 59 minutes
                end else begin
                    min_reg <= min_reg + 6'd1;
                end
            end
        end
    end

    // Handle hours
    always @(posedge clk_1hz or posedge time_ow) begin
        if (time_ow) begin
            // On reset, set the hours to the input value
            hour_reg <= hour_in;
        end else begin
            if (sec_reg == 6'd59 && min_reg == 6'd59) begin
                // Increment hours only when both seconds and minutes wrap around
                if (hour_reg == 5'd23) begin
                    hour_reg <= 5'd0; // Wrap around to 0 after 23 hours
                end else begin
                    hour_reg <= hour_reg + 5'd1;
                end
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

