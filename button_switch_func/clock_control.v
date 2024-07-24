module clock_control(
    input clk,           // System clock
    input btn_inc_hour,  // Button to increment hour
    input btn_dec_hour,  // Button to decrement hour
    input btn_inc_min,   // Button to increment minute
    input btn_dec_min,   // Button to decrement minute
    input btn_stop,      // Button to stop/start the clock
    output reg [4:0] hour,   // Current hour (0-23)
    output reg [5:0] minute, // Current minute (0-59)
    output reg running       // Clock running status
);

    // Debounced signals
    reg db_inc_hour, db_dec_hour, db_inc_min, db_dec_min, db_stop;

    // Debounce registers
    reg [15:0] db_cnt_inc_hour, db_cnt_dec_hour, db_cnt_inc_min, db_cnt_dec_min, db_cnt_stop;
    reg inc_hour_flag, dec_hour_flag, inc_min_flag, dec_min_flag, stop_flag;

    // Clock running status
    initial begin
        running = 1'b1;
    end

    // Debounce logic
    always @(posedge clk) begin
        // Increment hour button debounce
        if (btn_inc_hour) begin
            if (db_cnt_inc_hour < 16'hFFFF) db_cnt_inc_hour <= db_cnt_inc_hour + 1;
        end else begin
            db_cnt_inc_hour <= 0;
        end
        db_inc_hour <= (db_cnt_inc_hour == 16'hFFFF);

        // Decrement hour button debounce
        if (btn_dec_hour) begin
            if (db_cnt_dec_hour < 16'hFFFF) db_cnt_dec_hour <= db_cnt_dec_hour + 1;
        end else begin
            db_cnt_dec_hour <= 0;
        end
        db_dec_hour <= (db_cnt_dec_hour == 16'hFFFF);

        // Increment minute button debounce
        if (btn_inc_min) begin
            if (db_cnt_inc_min < 16'hFFFF) db_cnt_inc_min <= db_cnt_inc_min + 1;
        end else begin
            db_cnt_inc_min <= 0;
        end
        db_inc_min <= (db_cnt_inc_min == 16'hFFFF);

        // Decrement minute button debounce
        if (btn_dec_min) begin
            if (db_cnt_dec_min < 16'hFFFF) db_cnt_dec_min <= db_cnt_dec_min + 1;
        end else begin
            db_cnt_dec_min <= 0;
        end
        db_dec_min <= (db_cnt_dec_min == 16'hFFFF);

        // Stop/start button debounce
        if (btn_stop) begin
            if (db_cnt_stop < 16'hFFFF) db_cnt_stop <= db_cnt_stop + 1;
        end else begin
            db_cnt_stop <= 0;
        end
        db_stop <= (db_cnt_stop == 16'hFFFF);
    end

    // Control logic
    always @(posedge clk) begin
        // Hour control
        if (db_inc_hour && !inc_hour_flag) begin
            hour <= (hour == 5'd23) ? 5'd0 : (hour + 1);
            inc_hour_flag <= 1'b1;
        end else if (!db_inc_hour) begin
            inc_hour_flag <= 1'b0;
        end

        if (db_dec_hour && !dec_hour_flag) begin
            hour <= (hour == 5'd0) ? 5'd23 : (hour - 1);
            dec_hour_flag <= 1'b1;
        end else if (!db_dec_hour) begin
            dec_hour_flag <= 1'b0;
        end

        // Minute control
        if (db_inc_min && !inc_min_flag) begin
            minute <= (minute == 6'd59) ? 6'd0 : (minute + 1);
            inc_min_flag <= 1'b1;
        end else if (!db_inc_min) begin
            inc_min_flag <= 1'b0;
        end

        if (db_dec_min && !dec_min_flag) begin
            minute <= (minute == 6'd0) ? 6'd59 : (minute - 1);
            dec_min_flag <= 1'b1;
        end else if (!db_dec_min) begin
            dec_min_flag <= 1'b0;
        end

        // Stop/start control
        if (db_stop && !stop_flag) begin
            running <= ~running;
            stop_flag <= 1'b1;
        end else if (!db_stop) begin
            stop_flag <= 1'b0;
        end
    end
endmodule

