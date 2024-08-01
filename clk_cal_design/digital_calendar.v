// Digital Calendar Module
module digital_calendar#(parameter YEARRES = 12)(
    input clk,                                              // System clock signal
    input date_ow,                                          // Overwrite date
    input [4:0] hour_in,                                    // Hour input signal
    input [(YEARRES+8):0] date_in,                          // Date input signal in the format ddddd_mmmm_yyyyyyyyyyyy
    output [3:0] day_1s, day_10s,                           // BCD outputs for days
    output [3:0] month_1s, month_10s,                       // BCD outputs for months
    output [3:0] year_1s, year_10s, year_100s, year_1000s   // BCD outputs for years

);

    // Separate the input date into day, month, and year
    wire [4:0] day_in;
    wire [3:0] month_in;
    wire [(YEARRES-1):0] year_in;
    assign {day_in, month_in, year_in} = date_in;

    // Registers to store the current date
    reg [4:0] day_reg, day_reg_del;
    reg [3:0] month_reg, month_reg_del;
    reg [(YEARRES-1):0] year_reg;

    // Register to store the previous hour data
    reg [4:0] hour_reg;

    // Signals to detect a new day, new month, and new year
    reg new_day;
    wire new_year, new_month;

    // Edge detection for year and month changes
    assign new_year = (month_reg == 4'd1) & (month_reg_del != 4'd1);
    assign new_month = (day_reg == 4'd1) & (day_reg_del != 4'd1);

    // Detect a new day
    always @(posedge clk) begin
        new_day <= (hour_in == 5'd0) & (hour_reg == 5'd23);
    end

    // Generate delayed signals for edge detection
    always @(posedge clk) begin
        hour_reg <= hour_in;
        day_reg_del <= day_reg;
        month_reg_del <= month_reg;
    end

    // Handle year updates
    always @(posedge clk or posedge date_ow) begin
        if (date_ow) begin
            year_reg <= year_in;
        end else if (new_year) begin
            year_reg <= year_reg + {{(YEARRES-1){1'd0}}, 1'd1}; 
        end
    end

    // Handle month updates
    always @(posedge clk or posedge date_ow) begin
        if (date_ow) begin
            month_reg <= month_in;
        end else if (new_month) begin
            month_reg <= (month_reg == 4'd12) ? 4'd1 : (month_reg + 4'd1); 
        end
    end     

    // Handle day updates
    always @(posedge clk or posedge date_ow) begin
        if (date_ow) begin
            day_reg <= day_in;
        end else if (new_day) begin
            casex(month_reg)
                4'd2: begin // Special case for February
                    if (year_reg[1:0] == 2'b00) begin
                        day_reg <= (day_reg == 5'd29) ? 5'd1 : (day_reg + 5'd1);  
                    end else begin
                        day_reg <= (day_reg == 5'd28) ? 5'd1 : (day_reg + 5'd1);
                    end
                end
                4'b0??0: begin // Even months (April, June)
                    day_reg <= (day_reg == 5'd30) ? 5'd1 : (day_reg + 5'd1);
                end
                4'b0??1: begin // Odd months (January, March, May, July)
                    day_reg <= (day_reg == 5'd31) ? 5'd1 : (day_reg + 5'd1);
                end
                4'b1??0: begin // Even months (August, October, December)
                    day_reg <= (day_reg == 5'd31) ? 5'd1 : (day_reg + 5'd1);
                end
                4'b1??1: begin // Odd months (September, November)
                    day_reg <= (day_reg == 5'd30) ? 5'd1 : (day_reg + 5'd1);
                end
            endcase
        end
    end

    // convert binary values to output bcd values
    assign day_10s = day_reg / 10;
    assign day_1s  = day_reg % 10;
    assign month_10s = month_reg / 10;
    assign month_1s  = month_reg % 10;
    assign year_1000s = year_reg / 1000;
    assign year_100s  = (year_reg % 1000)/100;
    assign year_10s   = (year_reg % 100)/10;
    assign year_1s    = year_reg % 10;

endmodule

